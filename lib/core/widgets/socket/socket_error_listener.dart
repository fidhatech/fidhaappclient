import 'dart:developer';
import 'package:dating_app/core/network/socket/socket_service.dart';
import 'package:dating_app/core/utils/network_checker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SocketErrorListener extends StatefulWidget {
  final Widget child;
  final VoidCallback? onRetry;
  final String? retryLabel;

  const SocketErrorListener({
    super.key,
    required this.child,
    this.onRetry,
    this.retryLabel,
  });

  @override
  State<SocketErrorListener> createState() => _SocketErrorListenerState();
}

class _SocketErrorListenerState extends State<SocketErrorListener> {
  DateTime? _lastErrorTime;
  String? _lastErrorMessage;
  bool _isOffline = false;

  bool get _isAppInForeground =>
      WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;

  @override
  void initState() {
    super.initState();
    if (GetIt.instance.isRegistered<SocketService>()) {
      final socketService = GetIt.instance<SocketService>();

      // Listen for errors
      socketService.errorStream.listen((errorMessage) {
        if (!mounted) return;
        _handleError(errorMessage);
      });

      // Listen for connection success to clear errors
      socketService.connectionStatusStream.listen((isConnected) {
        if (!mounted) return;
        log('Listener: Connection status received: $isConnected');
        if (isConnected) {
          log('Listener: Hiding snackbar due to connection success');
          ScaffoldMessenger.of(context).clearSnackBars();
          _lastErrorMessage = null; // Reset error state
        }
      });
    }

    // Listen for connectivity changes
    if (GetIt.instance.isRegistered<NetworkChecker>()) {
      final networkChecker = GetIt.instance<NetworkChecker>();
      networkChecker.onConnectivityChanged.listen((isConnected) {
        if (!mounted) return;
        _isOffline = !isConnected;

        if (!isConnected) {
          if (!_isAppInForeground) {
            log(
              'Listener: Suppressing offline snackbar while app is backgrounded.',
            );
            return;
          }
          _showErrorSnackBar("No Internet Connection");
        } else {
          // If connection is back, we clear ANY outstanding connection error message.
          // This gives immediate feedback. If socket fails again, a new error will appear.
          ScaffoldMessenger.of(context).clearSnackBars();
          _lastErrorMessage = null;
        }
      });
    }
  }

  void _handleError(String errorMessage) {
    if (!_isAppInForeground) {
      log(
        'Listener: Suppressing socket error ($errorMessage) while app is backgrounded.',
      );
      return;
    }

    if (_shouldSuppressSocketSnackbar(errorMessage)) {
      log(
        'Listener: Suppressing transient socket error ($errorMessage) because auto-reconnect is already enabled.',
      );
      return;
    }

    // IGNORE socket errors if we know we are offline.
    // The "No Internet Connection" snackbar is already showing or sufficient.
    if (_isOffline) {
      log(
        'Listener: Ignoring socket error ($errorMessage) because device is offline.',
      );
      return;
    }

    log('Listener: Error received: $errorMessage');

    // SAFEGUARD: If socket thinks it's connected, ignore late errors
    if (GetIt.instance.isRegistered<SocketService>()) {
      if (GetIt.instance<SocketService>().isConnected) {
        log('Listener: Ignoring error because socket is connected');
        return;
      }
    }

    // Prevent duplicate SnackBars
    if (_lastErrorMessage == errorMessage &&
        _lastErrorTime != null &&
        DateTime.now().difference(_lastErrorTime!) <
            const Duration(seconds: 5)) {
      return;
    }

    _lastErrorMessage = errorMessage;
    _lastErrorTime = DateTime.now();

    _showErrorSnackBar(errorMessage);
  }

  bool _shouldSuppressSocketSnackbar(String errorMessage) {
    final normalizedMessage = errorMessage.trim().toLowerCase();
    return normalizedMessage == 'disconnected from server' ||
        normalizedMessage == 'cannot send data: socket not connected' ||
        normalizedMessage.startsWith('connection error:') ||
        normalizedMessage.startsWith('socket error:') ||
        normalizedMessage.contains('timeout') ||
        normalizedMessage.contains('socket connect error') ||
        normalizedMessage.contains('socketexception') ||
        normalizedMessage.contains('socketerror') ||
        normalizedMessage.contains('failed host lookup') ||
        normalizedMessage.contains('errno = 7');
  }

  void _showErrorSnackBar(String errorMessage) {
    if (!_isAppInForeground) {
      log('Listener: Skipping snackbar because app is not in foreground.');
      return;
    }

    // Sanitize technical errors
    String displayMessage = errorMessage;
    if (errorMessage.toLowerCase().contains("timeout")) {
      displayMessage = "Connection timed out. Retrying...";
    } else if (errorMessage.contains("SocketError") ||
        errorMessage.contains("SocketException") ||
        errorMessage.contains("errno = 7") ||
        errorMessage.contains("Failed host lookup")) {
      displayMessage = "Connection issue. Retrying...";
    } else if (errorMessage.contains("Connection Error") ||
        errorMessage.contains("Socket connect error")) {
      displayMessage = "Unable to connect to server.";
    }

    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Hide previous snackbars to avoid stacking
    scaffoldMessenger.hideCurrentSnackBar();

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(displayMessage),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
        duration: const Duration(days: 1), // Persistent until connected
        action: SnackBarAction(
          label: widget.onRetry != null
              ? (widget.retryLabel ?? 'Retry Now')
              : 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            scaffoldMessenger.hideCurrentSnackBar();
            if (widget.onRetry != null) {
              widget.onRetry!();
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
