import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppLifecycleService with WidgetsBindingObserver {
  static final AppLifecycleService _instance = AppLifecycleService._internal();

  factory AppLifecycleService() => _instance;

  AppLifecycleService._internal();

  AppLifecycleState? _lastState;

  /// Initialize the observer and apply safety patches
  void init() {
    WidgetsBinding.instance.addObserver(this);
    _lastState = WidgetsBinding.instance.lifecycleState;
    _applyLifecyclePatch();

    log('📱 AppLifecycleService: Initialized with Safety Patch');
  }

  /// Remove the observer
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    log('📱 AppLifecycleService: Disposed');
  }

  void _applyLifecyclePatch() {
    // This is a advanced patch level interceptor. i made this because it have a error on appcycle when when app mnimsed its a agent wise fix so if you have another idea u can re use it

    SystemChannels.lifecycle.setMessageHandler((String? message) async {
      final state = _parseState(message);

      if (state != null) {
        if (state == AppLifecycleState.paused &&
            _lastState == AppLifecycleState.inactive) {
          log(
            '📱 AppLifecycleService: Injecting missing "hidden" state to prevent crash',
          );
          // Manually trigger the missing 'hidden' transition before allowing 'paused'
          WidgetsBinding.instance.handleAppLifecycleStateChanged(
            AppLifecycleState.hidden,
          );
        }

        _lastState = state;

        // Continue with the original framework handling
        WidgetsBinding.instance.handleAppLifecycleStateChanged(state);
      }

      return message;
    });
  }

  AppLifecycleState? _parseState(String? stateString) {
    if (stateString == null) return null;
    return AppLifecycleState.values.firstWhere(
      (e) => e.toString() == stateString,
      orElse: () => AppLifecycleState.resumed,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    log('📱 AppLifecycleService: State changed to $state');
    _lastState = state;
  }
}
