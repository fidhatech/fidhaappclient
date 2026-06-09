import '../../data/models/auth_response_model.dart';
import '../../data/repositories/user_auth_repository.dart';

class VerifyOtpUsecase {
  final UserAuthRepository repo;
  VerifyOtpUsecase(this.repo);

  Future<VerifyOtpResponse> call(String phone, String otp) {
    return repo.verifyOtp(phone, otp);
  }
}
