import '../models/verify_otp_response/verify_otp_response_model.dart';

abstract class AuthenticationDatasource {

  Future<VerifyOtpResponseModel> verifyOtp({required String phone, required String otp});
}