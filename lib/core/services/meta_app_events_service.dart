import 'dart:developer';

import 'package:flutter_meta_appads_sdk/flutter_meta_appads_sdk.dart';

class MetaAppEventsService {
  MetaAppEventsService._();

  static final FlutterMetaAppAdsSdk _sdk = FlutterMetaAppAdsSdk();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) {
      return;
    }

    try {
      await _sdk.initSdk(enableLogging: true);
      await _sdk.setAutoLogAppEventsEnabled(isEnabled: true);
      _initialized = true;
      log('Meta App Events SDK initialized');
    } catch (error, stackTrace) {
      log(
        'Failed to initialize Meta App Events SDK: $error',
        stackTrace: stackTrace,
      );
    }
  }

  static Future<void> logAppOpened() async {
    try {
      await _sdk.logEvents(
        FBLogEventCommand(
          eventName: 'fidha_app_opened',
          eventParameters: {
            'source': 'startup',
          },
        ),
      );
    } catch (error, stackTrace) {
      log(
        'Failed to log Meta app opened event: $error',
        stackTrace: stackTrace,
      );
    }
  }
}