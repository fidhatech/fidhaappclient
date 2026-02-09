part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class ErrorState extends UserState {
  final String message;
  const ErrorState(this.message);
}

final class UserLoaded extends UserState {
  final UserModel userModel;
  const UserLoaded(this.userModel);
}
