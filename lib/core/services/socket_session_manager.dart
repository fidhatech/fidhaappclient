import 'dart:async';
import 'dart:developer';

import 'package:dating_app/core/network/socket/socket_service.dart';
import 'package:dating_app/core/storage/secure_storage.dart';
import 'package:flutter/material.dart';

class SocketSessionManager with WidgetsBindingObserver {
  final SocketService _socketService;

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  DateTime? _lastActiveAt;
  bool _isDisposed = false;
  String? _currentUserId;

  SocketSessionManager(this._socketService) {
    WidgetsBinding.instance.addObserver(this);
  }

  void setUserId(String userId) {
    _currentUserId = userId;
  }

  void startSession(String userId) {
    log('[SocketSessionManager] startSession called for $userId');
    _currentUserId = userId;
    _lastActiveAt = DateTime.now();
    _connect();
  }

  void _connect() {
    if (_currentUserId != null) {
      log('[SocketSessionManager] Connecting socket for user $_currentUserId');
      _socketService.connect(userId: _currentUserId!);
    }
  }

  void _disconnect() {
    log('[SocketSessionManager] Disconnecting socket.');
    _socketService.disconnect();
  }

  Future<void> clearSession() async {
    log(
      '[SocketSessionManager] Clearing session. Resetting user ID and disconnecting.',
    );
    _currentUserId = null;
    _lastActiveAt = null;
    await _socketService.disconnect(clear: true);
  }

  Future<void> logout() async {
    log('[SocketSessionManager] 🔴 Global Logout Triggered');

    // 1. Clear Session & Socket
    await clearSession();

    // 2. Clear All Storage (Redundant but safe)
    await SecureStorage.clearAll();

    // 3. Navigate to Login
    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      // Assuming '/' is the splash or login route that redirects based on auth state
      // Since we cleared tokens, it should go to Login/Onboarding
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } else {
      log(
        '[SocketSessionManager] ⚠️ Navigator context null, cannot navigate to login.',
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (_isDisposed) return;

    log('[SocketSessionManager] Lifecycle changed to: $state');

    switch (state) {
      case AppLifecycleState.resumed:
        _handleResume();
        break;
      case AppLifecycleState.paused:
      // case AppLifecycleState.inactive: // Don't disconnect on inactive (e.g. permission dialogs, split screen)
      case AppLifecycleState
          .detached: // On detached we might want to kill it too
      case AppLifecycleState.hidden: // Flutter 3.13+
        _handlePause();
        break;
      default:
        // Ignore inactive state to prevent disconnects during calls/dialogs
        log('[SocketSessionManager] Ignoring lifecycle state: $state');
        break;
    }
  }

  void _handlePause() {
    _lastActiveAt = DateTime.now();
    _disconnect();
  }

  void _handleResume() {
    if (_lastActiveAt == null) {
      // First launch or weird state? Just connect.
      _connect();
      return;
    }

    final inactiveDuration = DateTime.now().difference(_lastActiveAt!);
    log(
      '[SocketSessionManager] Inactive for ${inactiveDuration.inSeconds} seconds',
    );

    // Always silently reconnect if significantly inactive
    if (inactiveDuration.inMinutes >= 1) {
      log(
        '[SocketSessionManager] significant inactivity detected. Reconnecting socket silently.',
      );
      _disconnect();
      _connect();
    } else {
      // Just ensure connected
      _connect();
    }
  }

  /// Manually force a reconnect check (e.g. from Offline Screen)
  void checkAndReconnect() {
    log('[SocketSessionManager] Manual checkAndReconnect triggered.');
    // Check connectivity ideally; assume we try to connect and let service fail if no net
    _connect();
  }

  void dispose() {
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _disconnect();
  }
}
