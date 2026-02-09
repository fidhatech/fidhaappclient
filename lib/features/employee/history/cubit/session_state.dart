part of 'session_cubit.dart';

sealed class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object> get props => [];
}

final class SessionInitial extends SessionState {}

final class SessionLoading extends SessionState {}

final class SessionLoaded extends SessionState {
  final List<SessionModel> sessions;
  const SessionLoaded(this.sessions);
}

final class SessionError extends SessionState {
  final String message;
  const SessionError(this.message);
}
