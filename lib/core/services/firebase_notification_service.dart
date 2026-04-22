import 'dart:convert';
import 'dart:developer';
import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/widgets/app_confirmation%20dialog.dart/app_confirmation.dart';

import 'package:dating_app/core/network/http/dio_client.dart';
import 'package:dating_app/core/services/incoming_call_notification_bridge.dart';
import 'package:dating_app/core/services/local_notification_service.dart';
import 'package:dating_app/core/storage/secure_storage.dart';
import 'package:dating_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const int _staleCallGraceMs = 90 * 1000;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Handling a background message: ${message.messageId}');
  log('Background message data: ${message.data}');

  if (message.data['type'] == 'call') {
    final expiresAtRaw = message.data['callExpiresAt'];
    if (expiresAtRaw != null) {
      final expiresAt = int.tryParse(expiresAtRaw.toString());
      if (expiresAt != null &&
          DateTime.now().millisecondsSinceEpoch >
              expiresAt + _staleCallGraceMs) {
        log('Skipping stale background call notification: expired payload');
        return;
      }
    }

    IncomingCallNotificationBridge.publish(message.data);
    await LocalNotificationService.showIncomingCallNotification(message.data);
  } else {
    final title =
        message.notification?.title ??
        message.data['title'] ??
        message.data['notificationTitle'] ??
        'Fidha';
    final body =
        message.notification?.body ??
        message.data['body'] ??
        message.data['message'] ??
        message.data['description'] ??
        'You have a new notification.';

    await LocalNotificationService.showGenericNotification(
      title: title,
      body: body,
      payload: message.data.isEmpty ? null : jsonEncode(message.data),
      data: message.data,
    );
  }
}

class FirebaseNotificationService {
  static const MethodChannel _nativeNotificationActionChannel = MethodChannel(
    'fidha.app/notification_actions',
  );
  static bool _nativeActionHandlerAttached = false;

  static Future<void> init() async {
    // 1. Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 2. Setup Background Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    _setupNativeNotificationActionBridge();

    // 3. Setup Foreground Handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.data['type'] == 'call') {
        final expiresAtRaw = message.data['callExpiresAt'];
        if (expiresAtRaw != null) {
          final expiresAt = int.tryParse(expiresAtRaw.toString());
          if (expiresAt != null &&
              DateTime.now().millisecondsSinceEpoch >
                  expiresAt + _staleCallGraceMs) {
            log('Skipping stale foreground call notification: expired payload');
            return;
          }
        }

        final isForeground =
            WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;

        IncomingCallNotificationBridge.publish(message.data);

        if (!isForeground) {
          LocalNotificationService.showIncomingCallNotification(message.data);
        } else {
          log(
            'App is foreground; skipping system notification and using in-app incoming UI only.',
          );
        }
      } else if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
        LocalNotificationService.showGenericNotification(
          title:
              message.notification!.title ??
              message.data['title'] ??
              message.data['notificationTitle'] ??
              'New Notification',
          body:
              message.notification!.body ??
              message.data['body'] ??
              message.data['message'] ??
              message.data['description'] ??
              '',
          payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
          data: message.data,
        );
      } else if (message.data.isNotEmpty) {
        LocalNotificationService.showGenericNotification(
          title:
              message.data['title'] ??
              message.data['notificationTitle'] ??
              'New Notification',
          body:
              message.data['body'] ??
              message.data['message'] ??
              message.data['description'] ??
              'You have a new notification.',
          payload: jsonEncode(message.data),
          data: message.data,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['type'] == 'call') {
        IncomingCallNotificationBridge.publish(message.data);
      }
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null && initialMessage.data['type'] == 'call') {
      IncomingCallNotificationBridge.publish(initialMessage.data);
    }

    // 4. Cache FCM Token (Don't send to backend yet)
    await _cacheTokenInternal();

    // 4.1 Always sync token on app init for logged-in users.
    // This recovers from backend token drift even when token value didn't change.
    final accessToken = await SecureStorage.getAccessToken();
    if (accessToken != null) {
      await registerTokenWithBackend();
    }

    // 5. Setup Token Refresh Listener
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      log("🔄 FCM Token Refreshed: $newToken");
      await SecureStorage.saveFcmToken(newToken);

      // If user is logged in, sync with backend immediately
      final token = await SecureStorage.getAccessToken();
      if (token != null) {
        await registerTokenWithBackend();
      }
    });
  }

  static void _setupNativeNotificationActionBridge() {
    if (_nativeActionHandlerAttached) {
      return;
    }
    _nativeActionHandlerAttached = true;

    _nativeNotificationActionChannel.setMethodCallHandler((call) async {
      if (call.method != 'onNotificationAction') {
        return;
      }

      try {
        final args = Map<dynamic, dynamic>.from(call.arguments as Map);
        final payload = args['payload']?.toString();
        if (payload == null || payload.isEmpty) {
          return;
        }

        final decoded = jsonDecode(payload);
        if (decoded is! Map) {
          return;
        }

        final normalized = decoded.map(
          (key, value) => MapEntry(key.toString(), value),
        );
        final action = args['action']?.toString();
        if (action != null && action.isNotEmpty) {
          normalized['notificationAction'] = action;
        }

        IncomingCallNotificationBridge.publish(normalized);
      } catch (e) {
        log('Failed to handle native notification action bridge event: $e');
      }
    });
  }

  /// Gets token from Firebase and saves to SecureStorage
  static Future<void> _cacheTokenInternal() async {
    try {
      final newToken = await FirebaseMessaging.instance.getToken();
      if (newToken != null) {
        final oldToken = await SecureStorage.getFcmToken();

        if (oldToken != newToken) {
          log("🔄 FCM Token changed from stored version. Updating...");
          await SecureStorage.saveFcmToken(newToken);

          // If we are already logged in, we need to inform backend of this change immediately
          final accessToken = await SecureStorage.getAccessToken();
          if (accessToken != null) {
            await registerTokenWithBackend();
          }
        } else {
          log("✅ FCM Token matches stored version. No update needed.");
        }
      }
    } catch (e) {
      log("❌ Failed to cache FCM token: $e");
    }
  }

  /// Call this when User is Logged In + On Home Screen
  static Future<void> registerTokenWithBackend() async {
    final token = await SecureStorage.getFcmToken();
    if (token == null) {
      log("⚠️ No FCM token to register");
      return;
    }

    try {
      // Assuming DioClient handles the base URL
      await DioClient.instance.post(
        'user/fcm-token',
        data: {'fcmToken': token},
      );
      log("🚀 FCM Token successfully registered with backend");
    } catch (e) {
      if (e.toString().contains('403')) {
        log("⚠️ FCM Backend registration skipped (403 Forbidden)");
      } else {
        log("❌ Backend registration failed: $e");
      }
    }
  }

  static Future<void> requestPermissions() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    log('User granted permission: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      await registerTokenWithBackend();
    }
  }

  static Future<void> checkAndRequestPermission(BuildContext context) async {
    log("FirebaseNotificationService: checkAndRequestPermission started");
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.getNotificationSettings();
    log(
      "FirebaseNotificationService: Current status: ${settings.authorizationStatus}",
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User already granted permission');
      await registerTokenWithBackend(); // Ensure token is registered even if previously granted
      return;
    }

    if (context.mounted) {
      final granted = await showAppConfirmationDialog(
        context: context,
        title: 'Enable Notifications',
        message:
            'Enable notifications to receive incoming call alerts when the app is in foreground, background, or closed.',
        confirmText: 'Allow',
        cancelText: 'Cancel',
        confirmColor: AppColor.primaryButton,
      );

      if (granted && context.mounted) {
        requestPermissions();
      }
    }
  }
}
