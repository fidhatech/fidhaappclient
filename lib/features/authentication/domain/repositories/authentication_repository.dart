import '../entities/verify_otp_response.dart';

abstract class AuthenticationRepository {
  
  Future<VerifyOtpResponse> verifyOtp(String phone, String otp);
}