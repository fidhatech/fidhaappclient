import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../shared/domain/entities/failure.dart';
import '../../../domain/usecases/verify_otp.dart';

part 'otp_state.dart';
part 'otp_cubit.freezed.dart';

class OtpCubit extends Cubit<OtpState> {

  final VerifyOtp _verifyOtpUsecase;
  // final SendOtpUsecase sendOtpUsecase;
  // final ResendOtpUsecase resendOtpUsecase;

  OtpCubit() : 
    _verifyOtpUsecase = VerifyOtp(),
    super(const OtpState.initial());

  // Future<void> sendOtp(String phone) async {
  //   if (state is OtpLoading) return;
  //   emit(OtpLoading());
  //   try {
  //     final message = await sendOtpUsecase(phone);
  //     emit(OtpMessage(message));
  //   } catch (e) {
  //     emit(OtpError(mapError(e)));
  //   }
  // }

  // Future<void> resendOtp(String phone) async {
  //   if (state is OtpLoading) return;
  //   emit(OtpLoading());
  //   try {
  //     final message = await resendOtpUsecase(phone);
  //     emit(OtpMessage(message));
  //   } catch (e) {
  //     emit(OtpError(mapError(e)));
  //   }
  // }

  void verifyOtp(String phone, String otp) async {
    if (state is OtpLoading) return;

    emit(const OtpLoading());
    
    final result = await _verifyOtpUsecase.call((
      phone: phone, 
      otp: otp,
    ));
    
    result.fold(
      ifLeft: (value) => emit(OtpError(value)),
      ifRight: (value) => emit(
        OtpVerified(
          isExistingUser: value.isExistingUser, 
          userStage: value.userStage,
        ),
      ),
    );
  }
}
