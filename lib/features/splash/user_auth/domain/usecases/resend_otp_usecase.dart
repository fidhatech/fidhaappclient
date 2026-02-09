import 'package:dating_app/features/splash/user_auth/data/repositories/user_auth_repository.dart';

class ResendOtpUsecase {
  final UserAuthRepository repo;
  ResendOtpUsecase(this.repo);

  Future<String> call(String phone) {
    return repo.resendOtp(phone);
  }
}
