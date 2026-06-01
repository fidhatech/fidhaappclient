part of 'google_signin_cubit.dart';

sealed class GoogleSigninState extends Equatable {
  const GoogleSigninState();

  @override
  List<Object> get props => [];
}

final class GoogleSigninInitial extends GoogleSigninState {}
final class GoogleSigninProcessing extends GoogleSigninState {}
final class GoogleSigninSuccess extends GoogleSigninState {

  final String email;
  final bool userExists;
  
  const GoogleSigninSuccess({
    required this.email,
    required this.userExists,
  });

  @override
  List<Object> get props => [email, userExists];
}
final class GoogleSigninFailure extends GoogleSigninState {
  final String error;
  const GoogleSigninFailure({required this.error});

  @override
  List<Object> get props => [error];
}
