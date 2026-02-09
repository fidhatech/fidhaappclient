import 'package:dating_app/features/splash/user_auth/data/models/auth_response_model.dart';
import 'package:dating_app/features/splash/user_auth/data/repositories/user_auth_repository.dart';

class VerifyOtpUsecase {
  final UserAuthRepository repo;
  VerifyOtpUsecase(this.repo);

  Future<VerifyOtpResponse> call(String phone, String otp) {
    return repo.verifyOtp(phone, otp);
  }
}
