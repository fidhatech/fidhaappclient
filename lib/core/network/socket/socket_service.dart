import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dating_app/core/constants/api_constants.dart';
import 'package:dating_app/core/network/socket/socket_events.dart';
import 'package:dating_app/core/services/local_notification_service.dart';
import 'package:dating_app/core/storage/secure_storage.dart';
import 'package:dating_app/features/call/model/join_call_model.dart';
import 'package:dating_app/features/employee/call/models/incoming_call_model.dart';
import 'package:dating_app/features/user/features/home/models/home_response_model.dart';
import 'package:dating_app/features/user/features/home/models/home_update_response_model.dart';
import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

/// ═══════════════════════════════════════════════════════════════════════════
/// 📡 WEBSOCKET SERVICE - Real-Time Features
/// ═══════════════════════════════════════════════════════════════════════════
///
/// This service manages the WebSocket connection for REAL-TIME features:
///
/// 🎯 FEATURES USING WEBSOCKET:
/// ─────────────────────────────────────────────────────────────────────────
/// 1. 👥 EMPLOYEE LIST (normalEmployeesList)
///    - Stream of available employees for users to call
///    - Shows real-time availability
///    - Updated when employees come online/offline
///
/// 2. 🟢 EMPLOYEE STATUS (employeeStatusUpdate)
///    - Real-time status changes: AVAILABLE → BUSY → OFFLINE
///    - Used by Home & Premium screens
///    - Triggers UI updates for employee availability
///
/// 3. 📞 INCOMING CALL (incomingCall)
///    - Notifies employees of incoming calls
///    - Contains caller info and call metadata
///    - Triggers incoming call screen
///
/// 4. 🚀 JOIN CALL (joinCall)
///    - Sends Zego/call room details after acceptance
///    - Contains room ID, token, and media server info
///    - Enables employee to join the active call
///
/// 5. 🛑 CALL ENDED (callEnded)
///    - Notifies both parties when call is terminated
///    - Handles cleanup and session updates
///    - Updates call duration and billing info
///
/// ═══════════════════════════════════════════════════════════════════════════
class SocketService {
  io.Socket? _socket;
  bool _connecting = false;
  String? _connectedUserId;
  String? _lastToken; // Track the token used for the current connection
  final List<_QueuedSocketEmit> _queuedCriticalEmits = [];
  static const int _maxQueuedCriticalEmits = 20;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  // When true, the onDisconnect handler won't add an error — the disconnect
  // was triggered intentionally (reconnect/cleanup), not by a server drop.
  bool _isIntentionalDisconnect = false;

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

  String? get connectedUserId => _connectedUserId;

  void _startConnectivityMonitor() {
    if (_connectivitySubscription != null) return;

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      result,
    ) {
      final hasNetwork = !result.contains(ConnectivityResult.none);
      if (!hasNetwork) return;

      if ((_socket?.connected ?? false) || _connecting) return;
      if (_connectedUserId == null) return;

      log('🌐 Network restored. Attempting socket reconnect...');
      connect(userId: _connectedUserId!);
    });
  }

  void _ensureConnectedInBackground() {
    if (_connecting || isConnected) return;
    unawaited(ensureConnected(timeout: const Duration(seconds: 20)));
  }

  Future<void> connect({required String userId}) async {
    log('┌────────────────────────────────────────────────────────────');
    log('│ 🔌 WEBSOCKET CONNECTION INITIATED');
    log('├─ Time: ${DateTime.now().toIso8601String()}');
    log('├─ User ID: $userId');
    log('├─ Server URL: ${ApiConstants.baseUrl}');
    log(
      '├─ Current Socket State: ${_socket?.connected == true
          ? '✅ CONNECTED'
          : _socket == null
          ? '❌ NULL'
          : '❌ DISCONNECTED'}',
    );
    log('└────────────────────────────────────────────────────────────');

    final token = await SecureStorage.getAccessToken();

    // CRITICAL: If a socket exists but the TOKEN has changed (e.g. logout/login),
    // we MUST dispose it even if the userId is the same.
    if (_socket != null && _lastToken != token) {
      log(
        '🔄 CRITICAL: Token change detected (User: $userId). Forcing full reset.',
      );
      await disconnect(clear: false);
    }
    // Handle user ID mismatch separately for clarity
    else if (_socket != null && _connectedUserId != userId) {
      log(
        '🔄 CRITICAL: User ID mismatch (Current: $_connectedUserId, New: $userId). Forcing disposal.',
      );
      await disconnect(clear: false);
    } else if (_socket != null && !(_socket?.connected ?? false)) {
      // Dispose stale/disconnected socket before creating a fresh one.
      await disconnect(clear: false);
    }

    if (_socket?.connected ?? false || _connecting) {
      log('ℹ️  SKIPPED: Already connected or connecting for user: $userId');
      log('   Connected: ${_socket?.connected ?? false}');
      log('   Connecting: $_connecting');
      return;
    }

    if (token == null) {
      log('❌ CONNECTION FAILED: No access token available');
      log('   Status: Token is NULL - User may not be authenticated');
      _connecting = false;
      _connectedUserId = null;
      _lastToken = null;
      _errorController.add("No authentication token. Please login again.");
      return;
    }

    _connecting = true;
    _connectedUserId = userId;
    _lastToken = token;

    log('🔐 AUTHENTICATION READY');
    log(
      '├─ Token: ${token.substring(0, 20)}...${token.substring(token.length - 10)}',
    );
    log('├─ Token Length: ${token.length} characters');
    log('└─ User ID: $userId');

    log('⚙️  SOCKET OPTIONS CONFIGURED:');
    log('├─ Transport: websocket + polling fallback');
    log('├─ Auto-connect: Disabled');
    log('├─ Force New: Enabled');
    log('├─ Timeout: 20000ms (20 seconds)');
    log('├─ Reconnection: Enabled (unlimited attempts)');
    log('└─ Auth Headers: token + userId');

    _socket = io.io(
      ApiConstants.baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .disableAutoConnect()
          .enableForceNew()
          .enableReconnection()
          .setReconnectionAttempts(999999)
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .setTimeout(20000)
          .setAuth({'token': token, 'userId': userId})
          .build(),
    );

    log('📍 Socket instance created, registering listeners...');
    _registerCoreListeners();

    log('🚀 ATTEMPTING CONNECTION...');
    log('   Time: ${DateTime.now()}');
    _startConnectivityMonitor();
    _socket!.connect();
  }

  /// Force reconnect (useful for app resume scenarios)
  Future<void> reconnect({required String userId}) async {
    log('');
    log('╔════════════════════════════════════════════════════════════╗');
    log('║ 🔄 FORCE RECONNECTING WEBSOCKET                           ║');
    log('╠════════════════════════════════════════════════════════════╣');
    log('║ Current User: $_connectedUserId');
    log('║ Target User: $userId');
    log('║ Reason: App resume or explicit reconnection');
    log('║ Time: ${DateTime.now().toIso8601String()}');
    log('╚════════════════════════════════════════════════════════════╝');
    await disconnect(clear: false);
    await connect(userId: userId);
  }

  Future<bool> ensureConnected({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    if (isConnected) {
      return true;
    }

    final userId = _connectedUserId ?? await _inferUserIdFromAccessToken();
    if (userId == null || userId.isEmpty) {
      log('❌ ensureConnected failed: no connected user id available');
      return false;
    }

    _connectedUserId = userId;

    await connect(userId: userId);

    if (isConnected) {
      return true;
    }

    try {
      await connectionStatusStream
          .firstWhere((connected) => connected)
          .timeout(timeout);
      return true;
    } catch (_) {
      log('❌ ensureConnected timed out for user: $userId');
      return isConnected;
    }
  }

  Future<String?> _inferUserIdFromAccessToken() async {
    try {
      final token = await SecureStorage.getAccessToken();
      if (token == null || token.isEmpty) return null;

      final parts = token.split('.');
      if (parts.length < 2) return null;

      var payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      while (payload.length % 4 != 0) {
        payload += '=';
      }

      final decoded = utf8.decode(base64Decode(payload));
      final map = jsonDecode(decoded);
      if (map is Map<String, dynamic>) {
        final id = map['userId']?.toString();
        if (id != null && id.isNotEmpty) {
          return id;
        }
      }
    } catch (e) {
      log('⚠️ Failed to infer userId from access token: $e');
    }
    return null;
  }

  void onConnect(void Function(dynamic) handler) {
    _socket?.onConnect(handler);
  }

  /// Get detailed connection diagnostics (useful for debugging)
  String getConnectionDiagnostics() {
    final buffer = StringBuffer();
    buffer.writeln('');
    buffer.writeln(
      '╔════════════════════════════════════════════════════════════╗',
    );
    buffer.writeln(
      '║ 🔍 WEBSOCKET DIAGNOSTICS REPORT                           ║',
    );
    buffer.writeln(
      '╠════════════════════════════════════════════════════════════╣',
    );
    buffer.writeln('║ CONNECTION STATUS:');
    buffer.writeln(
      '║ ├─ Connected: ${_socket?.connected == true ? '✅ YES' : '❌ NO'}',
    );
    buffer.writeln('║ ├─ Socket Exists: ${_socket != null ? '✅ YES' : '❌ NO'}');
    buffer.writeln('║ ├─ Is Connecting: $_connecting');
    buffer.writeln('║ └─ Socket ID: ${_socket?.id ?? 'N/A'}');
    buffer.writeln('║');
    buffer.writeln('║ SESSION INFO:');
    buffer.writeln('║ ├─ Connected User: ${_connectedUserId ?? 'None'}');
    buffer.writeln('║ ├─ Has Token: ${_lastToken != null ? '✅ YES' : '❌ NO'}');
    buffer.writeln('║ └─ Token Length: ${_lastToken?.length ?? 0} chars');
    buffer.writeln('║');
    buffer.writeln('║ SERVER:');
    buffer.writeln('║ └─ URL: ${ApiConstants.baseUrl}');
    buffer.writeln('║');
    buffer.writeln('║ STREAMS:');
    buffer.writeln('║ ├─ Connection Status Stream: Active');
    buffer.writeln('║ ├─ Employee List Stream: Active');
    buffer.writeln('║ ├─ Status Update Stream: Active');
    buffer.writeln('║ ├─ Incoming Call Stream: Active');
    buffer.writeln('║ ├─ Join Call Stream: Active');
    buffer.writeln('║ ├─ Call Ended Stream: Active');
    buffer.writeln('║ └─ Error Stream: Active');
    buffer.writeln('║');
    buffer.writeln('║ FEATURES:');
    buffer.writeln(
      '║ ├─ Employee List: ${_socket?.connected == true ? '✅ Available' : '❌ Unavailable'}',
    );
    buffer.writeln(
      '║ ├─ Real-time Status: ${_socket?.connected == true ? '✅ Available' : '❌ Unavailable'}',
    );
    buffer.writeln(
      '║ ├─ Incoming Calls: ${_socket?.connected == true ? '✅ Available' : '❌ Unavailable'}',
    );
    buffer.writeln(
      '║ ├─ Call Join: ${_socket?.connected == true ? '✅ Available' : '❌ Unavailable'}',
    );
    buffer.writeln(
      '║ └─ Call Ended: ${_socket?.connected == true ? '✅ Available' : '❌ Unavailable'}',
    );
    buffer.writeln('║');
    buffer.writeln('║ TIMESTAMP: ${DateTime.now().toIso8601String()}');
    buffer.writeln(
      '╚════════════════════════════════════════════════════════════╝',
    );
    buffer.writeln('');

    final diagnostics = buffer.toString();
    log(diagnostics);
    return diagnostics;
  }

  void _registerCoreListeners() {
    log('📡 REGISTERING CORE WEBSOCKET LISTENERS...');
    log('─────────────────────────────────────────');

    // ✅ CONNECTION SUCCESS
    _socket!.onConnect((_) {
      _connecting = false;
      log('╔════════════════════════════════════════════════════════════╗');
      log('║ ✅ WEBSOCKET CONNECTION SUCCESSFUL                         ║');
      log('╠════════════════════════════════════════════════════════════╣');
      log('║ Socket ID: ${_socket?.id}');
      log('║ Connected User: $_connectedUserId');
      log('║ Server: ${ApiConstants.baseUrl}');
      log('║ Time: ${DateTime.now().toIso8601String()}');
      log('╠════════════════════════════════════════════════════════════╣');
      log('║ FEATURES NOW AVAILABLE:');
      log('║ 👥 Employee list updates');
      log('║ 🟢 Real-time status changes');
      log('║ 📞 Incoming call notifications');
      log('║ 🚀 Call join with room details');
      log('║ 🛑 Call end notifications');
      log('╚════════════════════════════════════════════════════════════╝');
      _flushQueuedCriticalEmits();
      _connectionStatusController.add(true);
    });

    // 🔄 RECONNECTION ATTEMPTS
    _socket!.onReconnectAttempt((attemptNumber) {
      log('🔄 RECONNECTION ATTEMPT #$attemptNumber');
      log('   Time: ${DateTime.now()}');
      log('   Status: Trying to reconnect...');
    });

    // ⚠️ DISCONNECTED
    _socket!.onDisconnect((_) {
      _connecting = false;
      final wasIntentional = _isIntentionalDisconnect;
      _isIntentionalDisconnect = false; // reset for next cycle
      log('╔════════════════════════════════════════════════════════════╗');
      log('║ ⚠️  WEBSOCKET DISCONNECTED                                 ║');
      log('╠════════════════════════════════════════════════════════════╣');
      log('║ Connected User: $_connectedUserId');
      log('║ Time: ${DateTime.now().toIso8601String()}');
      log(
        '║ Reason: ${wasIntentional ? 'Intentional (reconnecting)' : 'Server closed connection or network lost'}',
      );
      log('╠════════════════════════════════════════════════════════════╣');
      log('║ FEATURES NOW UNAVAILABLE:');
      log('║ ❌ Employee list updates');
      log('║ ❌ Real-time status changes');
      log('║ ❌ Incoming call notifications');
      log('║ ❌ Call data streaming');
      log('╠════════════════════════════════════════════════════════════╣');
      log(
        '║ ${wasIntentional ? 'Reconnecting now...' : 'Auto-reconnection: Will attempt every few seconds'}',
      );
      log('╚════════════════════════════════════════════════════════════╝');
      // Only surface an error when the server drops us unexpectedly.
      // Intentional disconnects (app resume reconnect, logout cleanup) are silent.
      if (!wasIntentional) {
        _errorController.add("Disconnected from server");
      }
      _connectionStatusController.add(false);
    });

    // 📡 ALL EVENTS TRACKER
    _socket!.onAny((event, data) {
      log('📨 [EVENT] $event → ${data.runtimeType}');
      if (event != SocketEvents.normalEmployeesList &&
          event != SocketEvents.employeeStatusUpdate) {
        log('   Data: $data');
      }
    });

    // ❌ CONNECTION ERROR (Authentication/Handshake failed)
    _socket!.onConnectError((err) async {
      _connecting = false;
      log('╔════════════════════════════════════════════════════════════╗');
      log('║ ❌ CONNECTION ERROR                                        ║');
      log('╠════════════════════════════════════════════════════════════╣');
      log('║ Error Type: ${err.runtimeType}');
      log('║ Error Message: $err');
      log('║ Time: ${DateTime.now().toIso8601String()}');
      log('╠════════════════════════════════════════════════════════════╣');

      final errorStr = err.toString().toLowerCase();
      if (errorStr.contains('401') || errorStr.contains('unauthorized')) {
        log('║ 🔑 ROOT CAUSE: AUTHENTICATION FAILED (401)');
        log('║ └─ Token may be expired or invalid');
        log('║ └─ Action: Clearing tokens and requesting re-login');
        log('╚════════════════════════════════════════════════════════════╝');
        await disconnect(clear: false);
      } else if (errorStr.contains('cors')) {
        log('║ 🌐 ROOT CAUSE: CORS ERROR');
        log('║ └─ Server CORS settings may not allow your domain');
        log('║ └─ Check server CORS configuration');
        log('╚════════════════════════════════════════════════════════════╝');
      } else if (errorStr.contains('timeout')) {
        log('║ ⏱️  ROOT CAUSE: CONNECTION TIMEOUT');
        log('║ └─ Server not responding within 5 seconds');
        log('║ └─ Check network and server status');
        log('╚════════════════════════════════════════════════════════════╝');
      } else {
        log('║ ❓ ROOT CAUSE: UNKNOWN');
        log('║ └─ Full error: $err');
        log('╚════════════════════════════════════════════════════════════╝');
      }

      _errorController.add("Connection Error: $err");
    });

    // 🔥 SOCKET ERROR (Runtime errors after connection)
    _socket!.onError((err) {
      _connecting = false;
      log('╔════════════════════════════════════════════════════════════╗');
      log('║ 🚨 SOCKET ERROR (Runtime)                                 ║');
      log('╠════════════════════════════════════════════════════════════╣');
      log('║ Error: $err');
      log('║ Time: ${DateTime.now().toIso8601String()}');
      log('╚════════════════════════════════════════════════════════════╝');
      _errorController.add("Socket Error: $err");
    });

    log('─────────────────────────────────────────');
    log('📡 EVENT LISTENERS REGISTERED:');
    log('  1️⃣  normalEmployeesList  → Employee list stream');
    log('  2️⃣  employeeStatusUpdate → Status change notifications');
    log('  3️⃣  incomingCall        → Incoming call alerts');
    log('  4️⃣  joinCall            → Call room & token info');
    log('  5️⃣  callEnded           → Call termination signal');
    log('');

    _socket!.on(SocketEvents.normalEmployeesList, (data) {
      try {
        log(
          '👥 [normalEmployeesList] Received ${data is List ? data.length : '?'} employees',
        );
        final model = HomeResponseModel.fromJson(data);
        _normalEmployeeController.add(model);
      } catch (e) {
        log('❌ Error parsing normalEmployeesList: $e');
        _errorController.add("Employee List Parse Error");
      }
    });

    _socket!.on(SocketEvents.employeeStatusUpdate, (data) {
      try {
        log(
          '🟢 [employeeStatusUpdate] ${data['employeeId']} → ${data['status']}',
        );
        final model = StatusUpdateModel.fromJson(data);
        _statusUpdateController.add(model);
      } catch (e) {
        log('❌ Error parsing employeeStatusUpdate: $e');
      }
    });

    _socket!.on(SocketEvents.incomingCall, (data) {
      log(
        '📞 [incomingCall] Incoming call from: ${data['callerName'] ?? data['callerId']}',
      );
      try {
        final isForeground =
            WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
        if (!isForeground && data is Map<String, dynamic>) {
          LocalNotificationService.showIncomingCallNotification(data);
        }

        final model = IncomingCallModel.fromJson(data);
        log('   ├─ Caller: ${model.callerName}');
        log('   ├─ Caller ID: ${model.callerId}');
        log('   └─ Call Type: ${model.callType}');
        _incomingCallController.add(model);
      } catch (e) {
        log('❌ Error parsing incomingCall: $e');
        _errorController.add("Incoming Call Parse Error");
      }
    });

    _socket!.on(SocketEvents.callEnded, (data) {
      log('🛑 [callEnded] Call terminated');
      log('   ├─ Reason: ${data['reason'] ?? 'Not specified'}');
      log('   ├─ Duration: ${data['duration'] ?? 'Unknown'}');
      log('   └─ Data: $data');
      _callEndedController.add(data);
    });

    _socket!.on(SocketEvents.joinCall, (data) {
      log('🚀 [joinCall] Employee joining call');
      try {
        log('   ├─ Room ID: ${data['roomId'] ?? 'Unknown'}');
        log(
          '   ├─ Token: ${data['token'] != null ? '${data['token'].toString().substring(0, 20)}...' : 'None'}',
        );
        final model = JoinCallModel.fromJson(data);
        _joinCallController.add(model);
      } catch (e) {
        log('❌ Error parsing joinCall: $e');
        _errorController.add("Join Call Parse Error");
      }
    });

    log('─────────────────────────────────────────');
  }

  /// emit safely
  void emit(String event, dynamic data) {
    if (!isConnected) {
      log('❌ [EMIT FAILED] Not connected');
      log('   ├─ Event: $event');
      log('   ├─ Data: $data');
      log('   ├─ Socket Connected: ${_socket?.connected}');
      log('   ├─ Socket Null: ${_socket == null}');
      log('   └─ Connected User: $_connectedUserId');

      if (_isCriticalCallEvent(event)) {
        _enqueueCriticalEmit(event, data);
        _ensureConnectedInBackground();
        return;
      }

      _errorController.add("Cannot send data: Socket not connected");
      _ensureConnectedInBackground();
      return;
    }
    log('📤 [EMIT] $event');
    log('   ├─ Data: $data');
    log('   └─ To: $_connectedUserId');
    _socket!.emit(event, data);
  }

  bool _isCriticalCallEvent(String event) {
    return event == SocketEvents.acceptCall ||
        event == SocketEvents.rejectCall ||
        event == SocketEvents.endCall;
  }

  void _enqueueCriticalEmit(String event, dynamic data) {
    final callId = _extractCallId(data);

    // Avoid duplicate queue entries for the same call operation.
    if (_queuedCriticalEmits.any(
      (item) => item.event == event && item.callId == callId,
    )) {
      log(
        '⏭️ [QUEUE] Duplicate critical emit skipped: $event (callId: $callId)',
      );
      return;
    }

    if (_queuedCriticalEmits.length >= _maxQueuedCriticalEmits) {
      final dropped = _queuedCriticalEmits.removeAt(0);
      log(
        '⚠️ [QUEUE] Queue full. Dropping oldest: ${dropped.event} (callId: ${dropped.callId})',
      );
    }

    _queuedCriticalEmits.add(
      _QueuedSocketEmit(event: event, data: data, callId: callId),
    );
    log(
      '🧾 [QUEUE] Queued critical emit: $event (callId: $callId). Pending: ${_queuedCriticalEmits.length}',
    );
  }

  void _flushQueuedCriticalEmits() {
    if (!isConnected || _queuedCriticalEmits.isEmpty) return;

    final toFlush = List<_QueuedSocketEmit>.from(_queuedCriticalEmits);
    _queuedCriticalEmits.clear();

    log('🚚 [QUEUE] Flushing ${toFlush.length} queued critical emit(s)...');
    for (final item in toFlush) {
      if (!isConnected) {
        // Connection dropped again while flushing; keep remaining for next reconnect.
        _queuedCriticalEmits.insertAll(0, toFlush.skip(toFlush.indexOf(item)));
        log('⚠️ [QUEUE] Flush interrupted by disconnect. Remaining re-queued.');
        return;
      }

      log('📤 [EMIT QUEUED] ${item.event} (callId: ${item.callId})');
      _socket!.emit(item.event, item.data);
    }
  }

  String _extractCallId(dynamic data) {
    if (data is Map<String, dynamic>) {
      final callId = data['callId']?.toString();
      if (callId != null && callId.isNotEmpty) {
        return callId;
      }
    }
    return 'unknown';
  }

  /// listen
  void on(String event, Function(dynamic) handler) {
    _socket?.off(event);
    _socket?.on(event, handler);
    log('🔔 Listener registered for: $event');
  }

  /// remove listener
  void off(String event) {
    _socket?.off(event);
    log('🔕 Listener removed for: $event');
  }

  Future<void> disconnect({bool clear = false}) async {
    log('─────────────────────────────────────────');
    log('🔌 INITIATING WEBSOCKET DISCONNECT');
    log('├─ User: $_connectedUserId');
    log('├─ Socket Active: ${_socket != null}');
    log('├─ Connected: ${_socket?.connected ?? false}');
    log('├─ Clear Tokens: $clear');
    log('└─ Time: ${DateTime.now().toIso8601String()}');

    await _connectivitySubscription?.cancel();
    _connectivitySubscription = null;

    if (_socket != null) {
      // Mark as intentional BEFORE calling disconnect() so the onDisconnect
      // handler knows not to surface a "Disconnected from server" error.
      _isIntentionalDisconnect = true;
      log('📍 Disconnecting socket...');
      _socket?.disconnect();
      log('🧹 Disposing socket...');
      _socket?.dispose();
      _socket = null;
      log('✅ Socket disposed');
    }

    _connecting = false;
    _connectedUserId = null;
    _lastToken = null;
    _queuedCriticalEmits.clear();

    if (clear) {
      log('🔐 Clearing all secure tokens from storage...');
      await SecureStorage.clearTokens();
      log('✅ Tokens cleared');
    }

    log('═════════════════════════════════════════');
    log('✅ WEBSOCKET FULLY DISCONNECTED & CLEANED');
    log('═════════════════════════════════════════');
  }
}

class _QueuedSocketEmit {
  final String event;
  final dynamic data;
  final String callId;

  _QueuedSocketEmit({
    required this.event,
    required this.data,
    required this.callId,
  });
}
