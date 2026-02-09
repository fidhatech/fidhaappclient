import 'package:dating_app/features/user/features/home/models/home_response_model.dart';
import 'package:dating_app/features/user/features/home/models/home_update_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class Intialize extends HomeEvent {}

class ConnectSocket extends HomeEvent {
  final String userId;
  const ConnectSocket(this.userId);

  @override
  List<Object?> get props => [userId];
}

class FetchMoreEmployee extends HomeEvent {
  const FetchMoreEmployee();
}

class Filter extends HomeEvent {
  final String language;
  const Filter([this.language = "en"]);
}

class SocketMessage extends HomeEvent {
  final HomeResponseModel data;

  const SocketMessage(this.data);

  @override
  List<Object?> get props => [data];
}

class StatusUpdate extends HomeEvent {
  final StatusUpdateModel data;

  const StatusUpdate(this.data);

  @override
  List<Object?> get props => [data];
}

class DisconnectSocket extends HomeEvent {
  const DisconnectSocket();
}

class ResetHome extends HomeEvent {}
