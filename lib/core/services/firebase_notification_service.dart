import 'dart:developer';
import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/widgets/app_confirmation%20dialog.dart/app_confirmation.dart';

import 'package:dating_app/core/network/http/dio_client.dart';
import 'package:dating_app/core/services/local_notification_service.dart';
import 'package:dating_app/core/storage/secure_storage.dart';
import 'package:dating_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Handling a background message: ${message.messageId}');
  log('Background message data: ${message.data}');

  if (message.data['type'] == 'call') {
    await LocalNotificationService.showIncomingCallNotification(message.data);
  } else if (message.notification != null) {
    log('Background notification: ${message.notification!.title}');
  }
}

class FirebaseNotificationService {
  static Future<void> init() async {
    // 1. Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 2. Setup Background Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. Setup Foreground Handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.data['type'] == 'call') {
        LocalNotificationService.showIncomingCallNotification(message.data);
      } else if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
        LocalNotificationService.showGenericNotification(
          title: message.notification!.title ?? 'New Notification',
          body: message.notification!.body ?? '',
          payload: message.data.isNotEmpty ? message.data.toString() : null,
        );
      }
    });

    // 4. Cache FCM Token (Don't send to backend yet)
    await _cacheTokenInternal();

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
        '/user/fcm-token',
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
            'We only send you notifications when the app is opened or minimised.',
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
