import 'dart:developer';
import 'package:flutter/widgets.dart';

class AppLifecycleService with WidgetsBindingObserver {
  static final AppLifecycleService _instance = AppLifecycleService._internal();

  factory AppLifecycleService() => _instance;

  AppLifecycleService._internal();

  /// Initialize the observer and apply safety patches
  void init() {
    WidgetsBinding.instance.addObserver(this);

    // Keep lifecycle handling passive. Intercepting SystemChannels.lifecycle
    // and re-dispatching states can generate duplicate transitions that
    // destabilize active calls and background/foreground flows.
    log('📱 AppLifecycleService: Initialized');
  }

  /// Remove the observer
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    log('📱 AppLifecycleService: Disposed');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    log('📱 AppLifecycleService: State changed to $state');
  }
}
