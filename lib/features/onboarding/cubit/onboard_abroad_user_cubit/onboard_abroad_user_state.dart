part of 'onboard_abroad_user_cubit.dart';

sealed class OnboardAbroadUserState extends Equatable {
  const OnboardAbroadUserState();

  @override
  List<Object> get props => [];
}

final class OnboardAbroadUserInitial extends OnboardAbroadUserState {}

final class OnboardAbroadUserLoading extends OnboardAbroadUserState {}

final class OnboardAbroadUserSuccess extends OnboardAbroadUserState {}

final class OnboardAbroadUserFailure extends OnboardAbroadUserState {
  final String message;
  const OnboardAbroadUserFailure(this.message);

  @override
  List<Object> get props => [message];
}
