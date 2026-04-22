import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dating_app/core/services/incoming_call_notification_bridge.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  final payload = response.payload;
  if (payload == null || payload.isEmpty) {
    return;
  }

  try {
    final decoded = jsonDecode(payload);
    if (decoded is Map<String, dynamic>) {
      final enriched = Map<String, dynamic>.from(decoded);
      if (response.actionId != null && response.actionId!.isNotEmpty) {
        enriched['notificationAction'] = response.actionId;
      }
      IncomingCallNotificationBridge.publish(enriched);
    }
  } catch (_) {
    // Ignore malformed payload in background callback.
  }
}

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static const MethodChannel _nativeNotificationActionChannel = MethodChannel(
    'fidha.app/notification_actions',
  );
  static bool _initialized = false;
  static final Map<String, int> _recentIncomingCallNotifications = {};
  static const String acceptActionId = 'accept_call';
  static const String declineActionId = 'decline_call';
  static const String _generalChannelId = 'high_importance_channel_v2';
  static const String _incomingCallChannelId = 'incoming_call_channel_v2';
  static const String _notificationSmallIcon = 'ic_launcher_monochrome';
  static const String _notificationLargeIcon = 'fidha_notification_logo';

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    _generalChannelId,
    'Pop-up Notifications',
    description:
        'Heads-up notifications for admin, revenue, and other important updates.',
    importance: Importance.max,
    playSound: true,
  );

  static final AndroidNotificationChannel
  _incomingCallChannel = AndroidNotificationChannel(
    _incomingCallChannelId,
    'Incoming Calls',
    description:
        'High-priority full-screen incoming call alerts with ringtone and vibration.',
    importance: Importance.max,
    playSound: true,
    sound: const UriAndroidNotificationSound(
      'content://settings/system/ringtone',
    ),
  );

  static Future<void> init() async {
    if (_initialized) {
      return;
    }

    // Initialize Local Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Note: iOS settings are omitted as per requirements
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log('Notification tapped: ${response.payload}');

        final payload = response.payload;
        if (payload == null || payload.isEmpty) {
          return;
        }

        try {
          final decoded = jsonDecode(payload);
          if (decoded is Map<String, dynamic>) {
            final enriched = Map<String, dynamic>.from(decoded);
            if (response.actionId != null && response.actionId!.isNotEmpty) {
              enriched['notificationAction'] = response.actionId;
            }
            IncomingCallNotificationBridge.publish(enriched);
          }
        } catch (e) {
          log('Failed to parse notification payload: $e');
        }
      },
    );

    // Create Notification Channel (Android only)
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_incomingCallChannel);

    _initialized = true;

    log('LocalNotificationService initialized');
  }

  static Future<void> restorePendingNotificationAction({
    bool forceLaunchDetailsCheck = false,
  }) async {
    try {
      await init();

      final launchDetails = await _notificationsPlugin
          .getNotificationAppLaunchDetails();
      if (launchDetails == null) {
        return;
      }

      if (!forceLaunchDetailsCheck && !launchDetails.didNotificationLaunchApp) {
        return;
      }

      final response = launchDetails.notificationResponse;
      if (response == null) {
        return;
      }

      final payload = response.payload;
      if (payload == null || payload.isEmpty) {
        return;
      }

      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        final enriched = Map<String, dynamic>.from(decoded);
        if (response.actionId != null && response.actionId!.isNotEmpty) {
          enriched['notificationAction'] = response.actionId;
        }
        IncomingCallNotificationBridge.publish(enriched);
      }
    } catch (e) {
      log('Failed to restore pending notification action: $e');
    }
  }

  static Future<void> showIncomingCallNotification(
    Map<String, dynamic> data,
  ) async {
    try {
      await init();

      final String callId = data['callId'] ?? 'unknown_call';
      final int now = DateTime.now().millisecondsSinceEpoch;
      final int? lastShownAt = _recentIncomingCallNotifications[callId];
      if (lastShownAt != null && (now - lastShownAt) < 8000) {
        return;
      }
      _recentIncomingCallNotifications[callId] = now;

      if (_recentIncomingCallNotifications.length > 50) {
        _recentIncomingCallNotifications.removeWhere(
          (_, ts) => (now - ts) > 60 * 1000,
        );
      }

      final String callerName = data['callerName'] ?? 'Unknown Caller';
      final String callType = data['callType'] ?? 'Voice Call';

      final AndroidNotificationDetails
      androidPlatformChannelSpecifics = AndroidNotificationDetails(
        _incomingCallChannelId,
        'Incoming Calls',
        channelDescription:
            'High-priority full-screen incoming call alerts with ringtone and vibration.',
        icon: _notificationSmallIcon,
        largeIcon: const DrawableResourceAndroidBitmap(_notificationLargeIcon),
        importance: Importance.max,
        priority: Priority.max,
        ticker: 'Incoming call',
        fullScreenIntent: true,
        category: AndroidNotificationCategory.call,
        visibility: NotificationVisibility.public,
        ongoing: true,
        autoCancel: false,
        onlyAlertOnce: false,
        playSound: true,
        sound: const UriAndroidNotificationSound(
          'content://settings/system/ringtone',
        ),
        enableVibration: true,
        vibrationPattern: Int64List.fromList(<int>[
          0,
          1000,
          800,
          1000,
          800,
          1200,
          700,
          1200,
        ]),
        audioAttributesUsage: AudioAttributesUsage.alarm,
        styleInformation: const BigTextStyleInformation(
          'Tap Accept to answer now. This alert is prioritized like an incoming phone call.',
          contentTitle: 'Incoming Call',
          summaryText: 'Swipe down for actions',
        ),
        timeoutAfter: 45000,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            acceptActionId,
            'Accept',
            showsUserInterface: true,
            cancelNotification: true,
          ),
          AndroidNotificationAction(
            declineActionId,
            'Decline',
            showsUserInterface: true,
            cancelNotification: true,
          ),
        ],
      );

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      // Use a consistent ID for calls or unique IDs if multiple calls are supported
      // Using hashcode of callId generic approach
      final int notificationId = callId.hashCode;

      await _notificationsPlugin.show(
        id: notificationId,
        title: 'Incoming $callType',
        body: '$callerName is calling...',
        notificationDetails: platformChannelSpecifics,
        payload: jsonEncode(data),
      );
    } catch (e) {
      log("Error showing notification: $e");
    }
  }

  static Future<void> cancelIncomingCallNotification(String callId) async {
    if (callId.isEmpty) {
      return;
    }

    try {
      await init();
      await _notificationsPlugin.cancel(id: callId.hashCode);
      await _nativeNotificationActionChannel.invokeMethod(
        'cancelIncomingCallNotification',
        <String, dynamic>{'callId': callId},
      );
    } catch (e) {
      log('Failed to cancel incoming call notification for $callId: $e');
    }
  }

  static Future<void> showGenericNotification({
    required String title,
    required String body,
    String? payload,
    Map<String, dynamic>? data,
  }) async {
    try {
      await init();

      final normalizedData = data ?? const <String, dynamic>{};
      final notificationType =
          normalizedData['type']?.toString().toLowerCase() ?? '';
      final notificationCategory =
          normalizedData['category']?.toString().toLowerCase() ?? '';
      final notificationStyle =
          normalizedData['notificationStyle']?.toString().toLowerCase() ?? '';
      final senderName =
          normalizedData['senderName']?.toString().trim().isNotEmpty == true
          ? normalizedData['senderName'].toString().trim()
          : 'Fidha Admin';

      final isAdminBroadcast =
          notificationType == 'broadcast' ||
          notificationCategory == 'admin' ||
          notificationStyle == 'social_card';

      final styleInformation = isAdminBroadcast
          ? MessagingStyleInformation(
              Person(
                name: senderName,
                key: 'admin_sender',
                bot: true,
                important: true,
              ),
              conversationTitle: 'Fidha Updates',
              groupConversation: false,
              messages: <Message>[
                Message(
                  body,
                  DateTime.now(),
                  Person(name: senderName, key: 'admin_sender'),
                ),
              ],
            )
          : BigTextStyleInformation(
              body,
              contentTitle: title,
              summaryText: 'Fidha',
            );

      final AndroidNotificationDetails
      androidPlatformChannelSpecifics = AndroidNotificationDetails(
        _generalChannelId,
        'Pop-up Notifications',
        channelDescription:
            'Heads-up notifications for admin, revenue, and other important updates.',
        icon: _notificationSmallIcon,
        largeIcon: const DrawableResourceAndroidBitmap(_notificationLargeIcon),
        importance: Importance.max,
        priority: Priority.max,
        ticker: title,
        visibility: NotificationVisibility.public,
        playSound: true,
        enableVibration: true,
        category: AndroidNotificationCategory.message,
        styleInformation: styleInformation,
      );

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await _notificationsPlugin.show(
        id: Object.hash(title, body, payload),
        title: title,
        body: body,
        notificationDetails: platformChannelSpecifics,
        payload: payload,
      );
    } catch (e) {
      log("Error showing generic notification: $e");
    }
  }
}
