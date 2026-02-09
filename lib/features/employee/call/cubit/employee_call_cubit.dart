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
      log('$_tag Call ended event received');
      if (state is! CallIdle) {
        safeEmit(CallIdle());
      }
    });
  }

  void acceptCall(String callId) {
    if (callId.isEmpty) {
      log('$_tag ❌ acceptCall aborted: Invalid callId');
      return;
    }

    if (state is! CallRinging) {
      log('$_tag ⚠️ acceptCall ignored: Not in ringing state. Current: $state');
      return;
    }

    log('$_tag Accepting call: $callId');
    safeEmit(CallAccepting(callId));

    final payload = {'callId': callId};
    socketService.emit(EmployeeConstants.eventAcceptCall, payload);
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
    safeEmit(CallIdle());
  }

  void reset() {
    log('$_tag 🧹 Resetting state');
    safeEmit(CallIdle());
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
    _callSubscription?.cancel();
    _callEndedSubscription?.cancel();
    _joinSub?.cancel();
    return super.close();
  }
}
