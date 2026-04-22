import 'dart:developer';
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dating_app/core/network/socket/socket_service.dart';
import 'package:dating_app/features/call/model/join_call_model.dart';
import 'package:dating_app/features/user/features/call/model/call_type.dart';
import 'package:dating_app/features/user/features/call/service/client_call_service.dart';
import 'package:dating_app/features/user/features/call/model/call_status.dart';
import 'package:meta/meta.dart';

part 'client_call_state.dart';

class ClientCallCubit extends Cubit<ClientCallState> {
  final ClientCallService _service;
  final SocketService _socketService;
  StreamSubscription? _joinSub;
  StreamSubscription? _endedSub;
  bool _isInitiating = false;
  // Single cancellable timer for all "reset to idle after 2s" paths.
  Timer? _resetTimer;

  void _scheduleReset() {
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 2), () {
      if (!isClosed) emit(ClientCallInitial());
    });
  }

  void _cancelReset() {
    _resetTimer?.cancel();
    _resetTimer = null;
  }

  String? _extractBackendErrorMessage(Object error) {
    if (error is! DioException) return null;
    final payload = error.response?.data;
    if (payload is! Map<String, dynamic>) return null;

    final errorObj = payload['error'];
    if (errorObj is Map<String, dynamic>) {
      final message = errorObj['message'];
      if (message is String) {
        return message;
      }
    }

    final message = payload['message'];
    if (message is String) {
      return message;
    }
    return null;
  }

  String _mapCallInitErrorMessage(String? code) {
    switch (code) {
      case 'INSUFFICIENT_COINS':
      case 'INSUFFICIENT_COINS_FOR_MINIMUM_DURATION':
        return 'Not enough coins to start this call.';
      case 'EMPLOYEE_OFFLINE':
        return 'She is currently offline.';
      case 'CALL_TYPE_NOT_AVAILABLE':
        return 'This call type is currently unavailable.';
      case 'EMPLOYEE_BUSY':
        return 'She is busy on another call.';
      case 'USER_ALREADY_IN_CALL':
        return 'You are already on a call.';
      case 'USER_NOT_CONNECTED':
        return 'Connection lost. Please try again.';
      default:
        return 'Call failed. Please try again.';
    }
  }

  ClientCallCubit(this._service, this._socketService)
    : super(ClientCallInitial()) {
    _joinSub = _socketService.joinCallStream.listen((data) {
      if (state.status == CallStatus.initiating ||
          state.status == CallStatus.ringing) {
        String callId = '';
        if (state is ClientCallWaiting) {
          callId = (state as ClientCallWaiting).callId ?? '';
        }
        if (callId.isNotEmpty) {
          emit(ClientCallJoined(data, callId: callId));
        }
      }
    });

    _endedSub = _socketService.callEndedStream.listen((data) {
      if (state.status != CallStatus.idle && state.status != CallStatus.ended) {
        emit(ClientCallEnded(data['reason'] ?? 'rejected'));
        _scheduleReset();
      }
    });
  }

  void initiateCall(
    String employeeId,
    String employeeName,
    String avatarUrl,
    CallType callType,
  ) async {
    log(
      '[ClientCallCubit-${identityHashCode(this)}] initiateCall START - Current Status: ${state.status}',
    );

    // If a previous call just ended and the 2s reset hasn't fired yet,
    // clear that ended state immediately so the user can call again right away.
    // Cancel any pending reset timer from a previous call so it can't
    // fire mid-new-call and silently flip state back to idle.
    _cancelReset();

    if (state.status == CallStatus.ended) {
      emit(ClientCallInitial());
    }

    if (state.status != CallStatus.idle || _isInitiating) {
      log(
        ' [ClientCallCubit-${identityHashCode(this)}] IGNORING call - State not IDLE/Busy',
      );
      return;
    }
    _isInitiating = true;

    try {
      log(
        ' [ClientCallCubit-${identityHashCode(this)}] Setting status to INITIATING',
      );
      emit(ClientCallInitiating());
      log(
        '[ClientCallCubit-${identityHashCode(this)}] Status after emit: ${state.status}',
      );

      log(' [ClientCallCubit-${identityHashCode(this)}] Calling Service...');
      final callData = await _service.initiatecall(employeeId, callType);
      log(
        ' [ClientCallCubit-${identityHashCode(this)}] Service returned success',
      );

      emit(
        ClientCallWaiting(
          avatarUrl: avatarUrl,
          callName: employeeName,
          callId: callData.callId,
        ),
      );
    } catch (e) {
      log('[ClientCallCubit-${identityHashCode(this)}] Error: $e');

      final backendMessage = _extractBackendErrorMessage(e);
      if (backendMessage == 'INSUFFICIENT_COINS' ||
          backendMessage == 'INSUFFICIENT_COINS_FOR_MINIMUM_DURATION') {
        emit(ClientCallInsufficientCoins());
        _scheduleReset();
        return;
      }

      emit(ClientCallError(_mapCallInitErrorMessage(backendMessage)));
      _scheduleReset();
    } finally {
      _isInitiating = false;
    }
  }

  void endCall(String callId) {
    if (state.status == CallStatus.idle) {
      log(' [ClientCallCubit] endCall ignored: already IDLE');
      return;
    }

    log(
      '[ClientCallCubit] endCall triggered for $callId. Emitting end_call socket event.',
    );
    _socketService.emit('end_call', {'callId': callId});

    log('[ClientCallCubit] Emitting ClientCallEnded state.');
    emit(ClientCallEnded('Canceled'));
    _scheduleReset();
  }

  @override
  Future<void> close() {
    _resetTimer?.cancel();
    _joinSub?.cancel();
    _endedSub?.cancel();
    return super.close();
  }
}
