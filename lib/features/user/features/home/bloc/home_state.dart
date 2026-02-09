import 'package:dating_app/features/user/features/home/models/home_response_model.dart';
import 'package:equatable/equatable.dart';

sealed class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class LoadingState extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeResponseModel responseModel;
  const HomeLoaded(this.responseModel);
  @override
  List<Object?> get props => [responseModel];
}

class ErrorState extends HomeState {
  final String message;
  const ErrorState(this.message);
}
