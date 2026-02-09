part of 'session_bloc.dart';

sealed class SessionEvent {
  const SessionEvent();
}

class FetchSession extends SessionEvent {}
