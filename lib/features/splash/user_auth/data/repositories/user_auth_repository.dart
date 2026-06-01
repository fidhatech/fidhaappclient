import 'package:dating_app/features/splash/user_auth/data/models/auth_response_model.dart';

import '../models/abroad_user_login_model.dart';

abstract class UserAuthRepository {
  Future<String> sendOtp(String phone);
  Future<VerifyOtpResponse> verifyOtp(String phone, String otp);

  Future<String> resendOtp(String phone);

  Future<AbroadUserLoginModel> checkUserExists(String email);
  Future<void> abroadUserLogin({
    required String email,
    required String name,
    required String phone,
  });
}
