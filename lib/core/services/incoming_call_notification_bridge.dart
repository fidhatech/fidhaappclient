import 'dart:async';

class IncomingCallNotificationBridge {
  static final StreamController<Map<String, dynamic>> _controller =
      StreamController<Map<String, dynamic>>.broadcast();

  static Map<String, dynamic>? _pending;

  static Stream<Map<String, dynamic>> get stream => _controller.stream;

  static void publish(Map<String, dynamic> data) {
    final normalized = Map<String, dynamic>.from(data);
    _pending = normalized;
    _controller.add(normalized);
  }

  static Map<String, dynamic>? consumePending() {
    final value = _pending;
    _pending = null;
    return value;
  }
}