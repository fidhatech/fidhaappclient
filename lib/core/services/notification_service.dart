import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dating_app/firebase_options.dart';
import 'package:flutter/material.dart';

// Top-level function for handling background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Handling a background message: ${message.messageId}');
  log('Background message data: ${message.data}');

  if (message.data['type'] == 'call') {
    await NotificationService.showIncomingCallNotification(message.data);
  }
}

class NotificationService {
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
    // 1. Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 2. Request Permissions (Removed auto-request)
    final messaging = FirebaseMessaging.instance;

    // 3. Initialize Local Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Note: iOS settings are omitted as per requirements
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log('Notification tapped: ${response.payload}');
        // Handle notification tap logic here (e.g., navigate to call screen)
      },
    );

    // 4. Create Notification Channel (Android only)
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // 5. Setup Background Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 6. Setup Foreground Handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }

      if (message.data['type'] == 'call') {
        showIncomingCallNotification(message.data);
      }
    });

    // Get FCM Token (Optional - for debugging)
    String? token = await messaging.getToken();
    log("FCM Token: $token");
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
  }

  static Future<void> checkAndRequestPermission(BuildContext context) async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User already granted permission');
      return;
    }

    if (context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Enable Notifications'),
          content: const Text(
            'To receive incoming calls properly, please enable notifications for this app.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                requestPermissions();
              },
              child: const Text('Allow'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    }
  }
}
