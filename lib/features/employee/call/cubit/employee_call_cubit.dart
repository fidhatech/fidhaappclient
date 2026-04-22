import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/core/network/socket/socket_service.dart';
import 'package:dating_app/features/call/model/join_call_model.dart';
import 'package:dating_app/features/employee/call/models/incoming_call_model.dart';
import 'package:dating_app/features/employee/constants/employee_constants.dart';

part 'employee_call_state.dart';

class EmployeeCallCubit extends Cubit<EmployeeCallState> {
  final SocketService socketService;
  static const String _tag = '[${EmployeeConstants.featureName}] CallCubit';

  StreamSubscription? _callSubscription;
  StreamSubscription? _callEndedSubscription;
  StreamSubscription? _joinSub;
  Timer? _acceptingTimer;
  DateTime? _lastAcceptStartedAt;
  String? _activeCallId;

  EmployeeCallCubit(this.socketService) : super(CallIdle()) {
    _initializeListeners();
  }

  void _initializeListeners() {
    // Incoming Call
    _callSubscription = socketService.incomingCallStream.listen((callData) {
      log('$_tag Incoming call received: ${callData.callId}');

      // Prevent overriding active call unless we have a strategy
      if (state is! CallIdle) {
        log(
          '$_tag ⚠️ Received incoming call while busy. Ignoring new call ${callData.callId}. Current state: $state',
        );
        return;
      }

      safeEmit(CallRinging(callData));
    });

    // Join Call (Accepted)
    _joinSub = socketService.joinCallStream.listen((data) {
      log('$_tag Join call event received: roomId=${data.roomId}');
      String callId = '';

      if (state is CallRinging) {
        callId = (state as CallRinging).callModel.callId;
      } else if (state is CallAccepting) {
        callId = (state as CallAccepting).callId;
      }

      if (callId.isNotEmpty) {
        _acceptingTimer?.cancel();
        _acceptingTimer = null;
        _activeCallId = callId;
        log('$_tag Transiting to CallJoining. CallId: $callId');
        safeEmit(CallJoining(data, callId: callId));
      } else {
        log(
          '$_tag ⚠️ Join event received but state mismatch (Expected Ringing/Accepting). Current: $state',
        );
      }
    });

    // Call Ended
    _callEndedSubscription = socketService.callEndedStream.listen((data) {
      final endedCallId = _extractCallId(data);
      final currentCallId = _currentCallId;

      if (endedCallId.isNotEmpty &&
          currentCallId.isNotEmpty &&
          endedCallId != currentCallId) {
        log(
          '$_tag Ignoring callEnded for unrelated callId=$endedCallId. Current active callId=$currentCallId',
        );
        return;
      }

      if (state is CallAccepting && endedCallId.isEmpty) {
        final elapsed = _lastAcceptStartedAt == null
            ? null
            : DateTime.now().difference(_lastAcceptStartedAt!);
        if (elapsed != null && elapsed < const Duration(seconds: 8)) {
          log(
            '$_tag Ignoring callEnded without callId during early accept window (${elapsed.inMilliseconds}ms).',
          );
          return;
        }
      }

      log('$_tag Call ended event received. callId=$endedCallId');
      if (state is! CallIdle) {
        _activeCallId = null;
        safeEmit(CallIdle());
      }
    });
  }

  Future<void> acceptCall(String callId) async {
    if (callId.isEmpty) {
      log('$_tag ❌ acceptCall aborted: Invalid callId');
      return;
    }

    if (state is CallAccepting && (state as CallAccepting).callId == callId) {
      log('$_tag ℹ️ acceptCall ignored: Already accepting callId=$callId');
      return;
    }

    IncomingCallModel? ringingModel;
    if (state is CallRinging) {
      ringingModel = (state as CallRinging).callModel;
    } else {
      log(
        '$_tag ⚠️ acceptCall invoked from non-ringing state. Proceeding with best-effort accept. Current: $state',
      );
    }

    log('$_tag Accepting call: $callId');
    _lastAcceptStartedAt = DateTime.now();
    _activeCallId = callId;
    safeEmit(CallAccepting(callId));

    // Allow extra time for socket to reconnect when app comes from background.
    final isReady = await socketService.ensureConnected(
      timeout: const Duration(seconds: 20),
    );
    if (!isReady) {
      log('$_tag ❌ acceptCall failed: socket not connected after 20s');
      if (ringingModel != null) {
        safeEmit(CallRinging(ringingModel));
      } else {
        safeEmit(CallIdle());
      }
      return;
    }

    final payload = {'callId': callId};
    socketService.emit(EmployeeConstants.eventAcceptCall, payload);
    log('$_tag accept_call emitted. Waiting for joinCall (timeout 25s)...');

    // If the server never responds with joinCall (call expired, network drop),
    // cancel the in-progress state so the UI doesn't stay frozen.
    _acceptingTimer?.cancel();
    _acceptingTimer = Timer(const Duration(seconds: 25), () {
      if (state is CallAccepting) {
        log('$_tag ⏱ No joinCall received after 25s. Reverting to CallIdle.');
        _activeCallId = null;
        safeEmit(CallIdle());
      }
    });
  }

  void rejectCall(String callId) {
    if (callId.isEmpty) {
      log('$_tag ❌ rejectCall aborted: Invalid callId');
      return;
    }

    if (state is! CallRinging) {
      log('$_tag ⚠️ rejectCall ignored: Not in ringing state. Current: $state');
      return;
    }

    log('$_tag Rejecting call: $callId');
    safeEmit(CallRejecting(callId));

    final payload = {'callId': callId};
    socketService.emit(EmployeeConstants.eventRejectCall, payload);

    _activeCallId = null;
    safeEmit(CallIdle());
  }

  void endCall(String callId) {
    if (callId.isEmpty) {
      log('$_tag ❌ endCall aborted: Invalid callId');
      return;
    }

    log('$_tag Ending call: $callId');
    final payload = {'callId': callId};
    socketService.emit(EmployeeConstants.eventEndCall, payload);
    _activeCallId = null;
    safeEmit(CallIdle());
  }

  void reset() {
    log('$_tag 🧹 Resetting state');
    _activeCallId = null;
    safeEmit(CallIdle());
  }

  void handlePushIncomingCall(Map<String, dynamic> rawData) {
    if (state is! CallIdle) {
      log('$_tag Push incoming call ignored. Current state: $state');
      return;
    }

    try {
      final normalized = Map<String, dynamic>.from(rawData);
      final rawCallType =
          (normalized['callType'] ?? normalized['callTypeDisplay'] ?? 'audio')
              .toString()
              .toLowerCase();

      normalized['callType'] = rawCallType.contains('video')
          ? 'video'
          : 'audio';

      final model = IncomingCallModel.fromJson(normalized);
      if (model.callId.isEmpty) {
        log('$_tag Push incoming call ignored: empty callId');
        return;
      }

      log('$_tag Push incoming call accepted: ${model.callId}');
      safeEmit(CallRinging(model));
    } catch (e) {
      log('$_tag Failed to handle push incoming call: $e');
    }
  }

  // Cancel the accepting-timeout whenever we transition away from CallAccepting.
  @override
  void onChange(Change<EmployeeCallState> change) {
    super.onChange(change);
    if (change.nextState is! CallAccepting) {
      _acceptingTimer?.cancel();
      _acceptingTimer = null;
    }

    if (change.nextState is CallIdle) {
      _activeCallId = null;
      _lastAcceptStartedAt = null;
    }
  }

  String get _currentCallId {
    if (_activeCallId != null && _activeCallId!.isNotEmpty) {
      return _activeCallId!;
    }
    if (state is CallRinging) {
      return (state as CallRinging).callModel.callId;
    }
    if (state is CallAccepting) {
      return (state as CallAccepting).callId;
    }
    if (state is CallJoining) {
      return (state as CallJoining).callId;
    }
    return '';
  }

  String _extractCallId(Map<String, dynamic> data) {
    final raw = data['callId'] ?? data['_id'] ?? data['id'];
    if (raw == null) return '';
    final value = raw.toString();
    return value.isEmpty ? '' : value;
  }

  // Guard against emitting after close
  void safeEmit(EmployeeCallState newState) {
    if (!isClosed) {
      emit(newState);
    } else {
      log('$_tag ⚠️ Attempted to emit $newState after Cubit closed');
    }
  }

  @override
  Future<void> close() {
    log('$_tag Closing Cubit');
    _acceptingTimer?.cancel();
    _activeCallId = null;
    _lastAcceptStartedAt = null;
    _callSubscription?.cancel();
    _callEndedSubscription?.cancel();
    _joinSub?.cancel();
    return super.close();
  }
}
