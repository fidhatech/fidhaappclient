part of 'employee_call_cubit.dart';

// employee_call_state.dart
abstract class EmployeeCallState {}

class CallIdle extends EmployeeCallState {}

class CallRinging extends EmployeeCallState {
  final IncomingCallModel callModel;
  CallRinging(this.callModel);
}

class CallRejecting extends EmployeeCallState {
  final String callId;
  CallRejecting(this.callId);
}

class CallAccepting extends EmployeeCallState {
  final String callId;
  CallAccepting(this.callId);
}

class CallJoining extends EmployeeCallState {
  final JoinCallModel joinData;
  final String callId;
  CallJoining(this.joinData, {required this.callId});
}
