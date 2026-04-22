import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';

class CallForegroundService {
  static const MethodChannel _channel = MethodChannel(
    'fidha.app/call_foreground_service',
  );

  static Future<void> start({
    required String callId,
    required String callType,
  }) async {
    if (!Platform.isAndroid) return;

    try {
      await _channel.invokeMethod('start', {
        'callId': callId,
        'callType': callType,
      });
    } catch (e) {
      log('CallForegroundService: failed to start foreground service: $e');
    }
  }

  static Future<void> stop() async {
    if (!Platform.isAndroid) return;

    try {
      await _channel.invokeMethod('stop');
    } catch (e) {
      log('CallForegroundService: failed to stop foreground service: $e');
    }
  }
}
