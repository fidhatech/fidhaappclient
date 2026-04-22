import 'package:dating_app/core/services/firebase_notification_service.dart';
import 'package:dating_app/core/storage/secure_storage.dart';
import 'package:dating_app/features/splash/user_auth/data/datasources/auth_remote_datasource.dart';
import 'package:dating_app/features/splash/user_auth/data/models/auth_response_model.dart';
import 'package:dating_app/features/splash/user_auth/data/repositories/user_auth_repository.dart';

class UserAuthRepositoryImpl implements UserAuthRepository {
  final AuthRemoteDatasource remote;
  UserAuthRepositoryImpl(this.remote);

  @override
  Future<String> sendOtp(String phone) {
    return remote.sendOtp(phone);
  }

  @override
  Future<VerifyOtpResponse> verifyOtp(String phone, String otp) async {
    final result = await remote.verifyOtp(phone, otp);

    await SecureStorage.saveTokens(
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    );
    await FirebaseNotificationService.registerTokenWithBackend();

    return result;
  }

  @override
  Future<String> resendOtp(String phone) {
    return remote.resendOtp(phone);
  }
}
