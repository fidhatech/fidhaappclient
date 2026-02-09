import 'dart:developer';

import 'package:dating_app/features/splash/user_auth/domain/usecases/resend_otp_usecase.dart';
import 'package:dating_app/features/splash/user_auth/domain/usecases/send_otp_usecase.dart';
import 'package:dating_app/features/splash/user_auth/domain/usecases/verify_otp_usecase.dart';
import 'package:dating_app/features/splash/user_auth/presentation/cubit/otp_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dating_app/core/utils/error_mapper.dart';

class OtpCubit extends Cubit<OtpState> {
  final SendOtpUsecase sendOtpUsecase;
  final VerifyOtpUsecase verifyOtpUsecase;
  final ResendOtpUsecase resendOtpUsecase;

  OtpCubit({
    required this.sendOtpUsecase,
    required this.verifyOtpUsecase,
    required this.resendOtpUsecase,
  }) : super(OtpInitial());

  Future<void> sendOtp(String phone) async {
    if (state is OtpLoading) return;
    emit(OtpLoading());
    try {
      final message = await sendOtpUsecase(phone);
      emit(OtpMessage(message));
    } catch (e) {
      emit(OtpError(mapError(e)));
    }
  }

  Future<void> resendOtp(String phone) async {
    if (state is OtpLoading) return;
    emit(OtpLoading());
    try {
      final message = await resendOtpUsecase(phone);
      emit(OtpMessage(message));
    } catch (e) {
      emit(OtpError(mapError(e)));
    }
  }

  Future<void> verifyOtp(String phone, String otp) async {
    if (state is OtpLoading) return;
    emit(OtpLoading());
    try {
      final result = await verifyOtpUsecase(phone, otp);
      log(result.toString());

      emit(OtpVerified(result.isExistingUser, userStage: result.userStage));
    } catch (e) {
      emit(OtpError(mapError(e)));
    }
  }
}
