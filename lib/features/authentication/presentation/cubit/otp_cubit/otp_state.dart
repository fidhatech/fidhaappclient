part of 'otp_cubit.dart';

@freezed
sealed class OtpState with _$OtpState {
  const factory OtpState.initial() = OtpInitial;
  const factory OtpState.loading() = OtpLoading;
  const factory OtpState.message(String message) = OtpMessage;
  const factory OtpState.error(Failure failure) = OtpError;
  const factory OtpState.verified({
    required bool isExistingUser, 
    required String? userStage,
  }) = OtpVerified;
}
