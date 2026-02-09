import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dating_app/core/constants/api_constants.dart';
import 'package:dating_app/core/network/socket/socket_events.dart';
import 'package:dating_app/core/storage/secure_storage.dart';
import 'package:dating_app/features/call/model/join_call_model.dart';
import 'package:dating_app/features/employee/call/models/incoming_call_model.dart';
import 'package:dating_app/features/user/features/home/models/home_response_model.dart';
import 'package:dating_app/features/user/features/home/models/home_update_response_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  io.Socket? _socket;
  bool _connecting = false;
  String? _connectedUserId;
  String? _lastToken; // Track the token used for the current connection
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  bool get isConnected => _socket?.connected ?? false;
  final _statusUpdateController =
      StreamController<StatusUpdateModel>.broadcast();
  final _normalEmployeeController =
      StreamController<HomeResponseModel>.broadcast();
  final _incomingCallController =
      StreamController<IncomingCallModel>.broadcast();
  final _callEndedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _joinCallController = StreamController<JoinCallModel>.broadcast();
  final _errorController = StreamController<String>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();

  // Add this getter
  Stream<JoinCallModel> get joinCallStream => _joinCallController.stream;
  Stream<String> get errorStream => _errorController.stream;
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;
  Stream<Map<String, dynamic>> get callEndedStream =>
      _callEndedController.stream;
  Stream<IncomingCallModel> get incomingCallStream =>
      _incomingCallController.stream;

  Stream<StatusUpdateModel> get statusStream => _statusUpdateController.stream;
  Stream<HomeResponseModel> get employeeStream =>
      _normalEmployeeController.stream;
  Future<void> connect({required String userId}) async {
    log("socketconnect called for user: $userId");

    final token = await SecureStorage.getAccessToken();

    // CRITICAL: If a socket exists but the TOKEN has changed (e.g. logout/login),
    // we MUST dispose it even if the userId is the same.
    if (_socket != null && _lastToken != token) {
      log(
        '🔄 Socket: Token change detected (User: $userId). Forcing full reset.',
      );
      await disconnect(clear: false);
    }
    // Handle user ID mismatch separately for clarity
    else if (_socket != null && _connectedUserId != userId) {
      log(
        '🔄 Socket: User ID mismatch (Current: $_connectedUserId, New: $userId). Forcing disposal.',
      );
      await disconnect(clear: false);
    }

    if (_socket?.connected ?? false || _connecting) {
      log('ℹ️ Socket: Already connected or connecting for user: $userId');
      return;
    }

    if (token == null) {
      log('❌ Socket: no access token');
      _connecting = false;
      _connectedUserId = null;
      _lastToken = null;
      return;
    }

    _connecting = true;
    _connectedUserId = userId;
    _lastToken = token;
    log(
      '🔐 Socket: Using token starting with ${token.substring(0, 10)}... for user $userId',
    );

    _socket = io.io(
      ApiConstants.baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableForceNew()
          .setTimeout(5000)
          .setAuth({'token': token, 'userId': userId})
          .build(),
    );

    _registerCoreListeners();
    _socket!.connect();
  }

  /// Force reconnect (useful for app resume scenarios)
  Future<void> reconnect({required String userId}) async {
    log('🔄 Socket: Force reconnecting for user $userId...');
    await disconnect(clear: false);
    await connect(userId: userId);
  }

  void onConnect(void Function(dynamic) handler) {
    _socket?.onConnect(handler);
  }

  void _registerCoreListeners() {
    _socket!.onConnect((_) {
      _connecting = false;
      log('✅ Socket connected');
      _connectionStatusController.add(true);
    });
    _socket!.onReconnectAttempt((attemptNumber) {
      log('🔄 Socket: Reconnection attempt #$attemptNumber');
    });
    _socket!.onDisconnect((_) {
      _connecting = false;
      log('⚠️ Socket disconnected');
      _errorController.add("Disconnected from server");
      _connectionStatusController.add(false);
    });

    _socket!.onAny((event, data) {
      log(' Event received: $event with data: $data');
    });
    _socket!.onConnectError((err) async {
      _connecting = false;
      log(' Socket connect error: $err');
      _errorController.add("Connection Error: $err");

      // token expired → let SessionManager handle it via error stream if needed
      if (err.toString().contains('401')) {
        log('❌ Socket: Auth error (401). Forcing disconnect.');
        await disconnect(
          clear: false,
        ); // Don't clear tokens yet, might be transient or handled by Dio interceptor
      }
    });

    _socket!.onError((err) {
      _connecting = false;
      log('❌ Socket error: $err');
      _errorController.add("Socket Error: $err");
    });

    _socket!.on(SocketEvents.normalEmployeesList, (data) {
      try {
        final model = HomeResponseModel.fromJson(data);
        _normalEmployeeController.add(model);
      } catch (e) {
        log('❌ Error parsing HomeResponseModel: $e');
        _errorController.add("Data Parse Error: Home List");
      }
    });

    // 2. Listen for Status Changes (Home & Premium Pages)
    _socket!.on(SocketEvents.employeeStatusUpdate, (data) {
      try {
        final model = StatusUpdateModel.fromJson(data);
        _statusUpdateController.add(model);
      } catch (e) {
        log('❌ Error parsing StatusUpdateModel: $e');
      }
    });
    _socket!.on(SocketEvents.incomingCall, (data) {
      log('📞 Socket: Incoming Call Received - $data');
      try {
        final model = IncomingCallModel.fromJson(data);
        _incomingCallController.add(model);
      } catch (e) {
        log('❌ Socket Error parsing IncomingCallModel: $e');
        _errorController.add("Call Error: Invalid Data");
      }
    });
    _socket!.on(SocketEvents.callEnded, (data) {
      log('🛑 Socket: Call Ended by remote - $data');
      _callEndedController.add(data);
    });
    // Inside SocketService _registerCoreListeners()

    _socket!.on(SocketEvents.joinCall, (data) {
      log('🚀 Socket: Join Call received: $data');
      try {
        final model = JoinCallModel.fromJson(data);
        _joinCallController.add(model);
      } catch (e) {
        log('❌ Error parsing JoinCallModel: $e');
        _errorController.add("Call Join Error");
      }
    });
  }

  /// emit safely
  void emit(String event, dynamic data) {
    if (!isConnected) {
      log('❌ Socket Emit Failed: Not connected. Event: $event');
      return;
    }
    log('📤 Socket Emitting: $event with data: $data');
    _socket!.emit(event, data);
  }

  /// listen
  void on(String event, Function(dynamic) handler) {
    _socket?.off(event);
    _socket?.on(event, handler);
  }

  /// remove listener
  void off(String event) {
    _socket?.off(event);
  }

  Future<void> disconnect({bool clear = false}) async {
    await _connectivitySubscription?.cancel();
    _connectivitySubscription = null;

    if (_socket != null) {
      log(
        '🔌 Socket: Disconnecting and disposing socket for $_connectedUserId',
      );
      _socket?.disconnect();
      _socket?.dispose();
      _socket = null;
    }

    _connecting = false;
    _connectedUserId = null;
    _lastToken = null;

    if (clear) {
      log('🧹 Socket: Clearing all secure tokens');
      await SecureStorage.clearTokens();
    }

    log('🔌 Socket disposed and session cleared');
  }
}
