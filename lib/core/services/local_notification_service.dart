import 'dart:convert';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    playSound: true,
  );

  static Future<void> init() async {
    // Initialize Local Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Note: iOS settings are omitted as per requirements
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log('Notification tapped: ${response.payload}');
        // Handle notification tap logic here
      },
    );

    // Create Notification Channel (Android only)
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    log('LocalNotificationService initialized');
  }

  static Future<void> showIncomingCallNotification(
    Map<String, dynamic> data,
  ) async {
    try {
      final String callId = data['callId'] ?? 'unknown_call';
      final String callerName = data['callerName'] ?? 'Unknown Caller';
      final String callType = data['callType'] ?? 'Voice Call';

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            fullScreenIntent: true, // Important for incoming calls
            category: AndroidNotificationCategory.call,
            visibility: NotificationVisibility.public,
            timeoutAfter: 30000, // Cancel after 30 seconds if not answered
          );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
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

  static Future<void> showGenericNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            visibility: NotificationVisibility.public,
          );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await _notificationsPlugin.show(
        id: DateTime.now().millisecond, // Unique ID
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
