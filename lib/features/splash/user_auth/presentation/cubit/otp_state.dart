import 'package:equatable/equatable.dart';

abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object?> get props => [];
}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpMessage extends OtpState {
  final String message;

  const OtpMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class OtpVerified extends OtpState {
  final bool isExistingUser;
  final String? userStage;

  const OtpVerified(this.isExistingUser, {this.userStage});

  @override
  List<Object?> get props => [isExistingUser, userStage];
}

class OtpError extends OtpState {
  final String message;

  const OtpError(this.message);

  @override
  List<Object?> get props => [message];
}
