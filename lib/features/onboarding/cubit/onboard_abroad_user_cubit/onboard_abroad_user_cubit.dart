import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../di/injection.dart';
import '../../service/onboarding_service.dart';

part 'onboard_abroad_user_state.dart';

class OnboardAbroadUserCubit extends Cubit<OnboardAbroadUserState> {
  OnboardAbroadUserCubit() : super(OnboardAbroadUserInitial());

  void onboardUser({
    required String email,
    required String name,
    required String phone,
  }) async {
    emit(OnboardAbroadUserLoading());
    try {
      await sl<OnboardingService>().submitAbroadUserDetails(
        email: email, 
        name: name, 
        phone: phone,
      );
      emit(OnboardAbroadUserSuccess());
    } catch (e) {
      emit(OnboardAbroadUserFailure(e.toString()));
    }
  }
}
