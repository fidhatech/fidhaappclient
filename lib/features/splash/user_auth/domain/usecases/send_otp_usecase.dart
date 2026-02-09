import 'package:dating_app/features/splash/user_auth/data/repositories/user_auth_repository.dart';

class SendOtpUsecase {
  final UserAuthRepository repo;
  SendOtpUsecase(this.repo);

  Future<String> call(String phone) {
    return repo.sendOtp(phone);
  }
}
