import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/signin_with_google_usecase.dart';

part 'google_signin_state.dart';

class GoogleSigninCubit extends Cubit<GoogleSigninState> {
  GoogleSigninCubit() : super(GoogleSigninInitial());

  Future<void> signInWithGoogle() async {
    try {
      emit(GoogleSigninProcessing());

      final res = await SigninWithGoogleUsecase().call();
      emit(
        GoogleSigninSuccess(
          email: res.email, 
          userExists: res.userExists,
        ),
      );
    } catch (e) {
      log(e.toString());
      emit(GoogleSigninFailure(error: e.toString()));
    }
  }
}
