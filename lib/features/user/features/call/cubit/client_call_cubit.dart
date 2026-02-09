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
        Future.delayed(
          const Duration(seconds: 2),
          () => emit(ClientCallInitial()),
        );
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
      _isInitiating = false;
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
      _isInitiating = false;

      if (e is DioException && e.response?.data != null) {
        try {
          final data = e.response!.data;
          if (data is Map<String, dynamic>) {
            final errorObj = data['error'];
            if (errorObj is Map<String, dynamic> &&
                errorObj['message'] == 'INSUFFICIENT_COINS') {
              emit(ClientCallInsufficientCoins());
              Future.delayed(
                const Duration(seconds: 2),
                () => emit(ClientCallInitial()),
              );
              return;
            }
          }
        } catch (parseError) {
          log('Error parsing Dio error response: $parseError');
        }
      }

      emit(ClientCallError(e.toString()));
      Future.delayed(
        const Duration(seconds: 2),
        () => emit(ClientCallInitial()),
      );
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

    Future.delayed(const Duration(seconds: 2), () {
      if (!isClosed) {
        log('[ClientCallCubit] Resetting to ClientCallInitial.');
        emit(ClientCallInitial());
      }
    });
  }

  @override
  Future<void> close() {
    _joinSub?.cancel();
    _endedSub?.cancel();
    return super.close();
  }
}
