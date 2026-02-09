import 'package:equatable/equatable.dart';

abstract class EmployeeVoiceState extends Equatable {
  const EmployeeVoiceState();

  @override
  List<Object?> get props => [];
}

class EmployeeVoiceInitial extends EmployeeVoiceState {}

class EmployeeVoiceRecording extends EmployeeVoiceState {}

class EmployeeVoiceRecorded extends EmployeeVoiceState {
  final String audioPath;

  const EmployeeVoiceRecorded({required this.audioPath});

  @override
  List<Object?> get props => [audioPath];
}

class EmployeeVoiceError extends EmployeeVoiceState {
  final String message;

  const EmployeeVoiceError({required this.message});

  @override
  List<Object?> get props => [message];
}
