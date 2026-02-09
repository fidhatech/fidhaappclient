part of 'client_call_cubit.dart';

@immutable
sealed class ClientCallState {
  CallStatus get status;
}

final class ClientCallInitial extends ClientCallState {
  @override
  CallStatus get status => CallStatus.idle;
}

final class ClientCallInitiating extends ClientCallState {
  @override
  CallStatus get status => CallStatus.initiating;
}

final class ClientCallWaiting extends ClientCallState {
  final String callName;
  final String avatarUrl;
  final String? callId;
  ClientCallWaiting({
    required this.avatarUrl,
    required this.callName,
    this.callId,
  });

  @override
  CallStatus get status => CallStatus.ringing;
}

final class ClientCallJoined extends ClientCallState {
  final JoinCallModel joinData;
  final String callId;
  ClientCallJoined(this.joinData, {required this.callId});

  @override
  CallStatus get status => CallStatus.connected;
}

final class ClientCallEnded extends ClientCallState {
  final String reason;
  ClientCallEnded(this.reason);

  @override
  CallStatus get status => CallStatus.ended;
}

final class ClientCallError extends ClientCallState {
  final String message;
  ClientCallError(this.message);

  @override
  CallStatus get status => CallStatus.idle;
}

final class ClientCallInsufficientCoins extends ClientCallState {
  @override
  CallStatus get status => CallStatus.idle;
}
