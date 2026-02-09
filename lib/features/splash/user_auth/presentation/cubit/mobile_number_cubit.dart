import 'package:dating_app/features/splash/user_auth/presentation/cubit/mobile_number_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MobileNumberCubit extends Cubit<MobileNumberState> {
  MobileNumberCubit() : super(const MobileNumberInitial());
  void onNumberChanged(String number, {required bool valid}) {
    emit(
      (state as MobileNumberInitial).copyWith(
        mobileNumber: number,
        isValid: valid,
      ),
    );
  }
}
