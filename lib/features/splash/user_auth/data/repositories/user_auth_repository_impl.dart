import '../../../../../core/di/di.dart';
import '../../../../../core/services/firebase_notification_service.dart';
import '../../../../../core/services/secure_storage.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_response_model.dart';
import 'user_auth_repository.dart';

import '../models/abroad_user_login_model.dart';

class UserAuthRepositoryImpl implements UserAuthRepository {
  final AuthRemoteDatasource remote;
  
  const UserAuthRepositoryImpl(this.remote);

  @override
  Future<String> sendOtp(String phone) {
    return remote.sendOtp(phone);
  }

  @override
  Future<VerifyOtpResponse> verifyOtp(String phone, String otp) async {
    final result = await remote.verifyOtp(phone, otp);

    await getIt.get<SecureStorage>().saveTokens(
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    );
    await getIt.get<FirebaseNotificationService>().registerTokenWithBackend();

    return result;
  }

  @override
  Future<String> resendOtp(String phone) {
    return remote.resendOtp(phone);
  }
  
  @override
  Future<AbroadUserLoginModel> abroadUserLogin({required String email, required String name, required String phone}) {
    // TODO: implement abroadUserLogin
    throw UnimplementedError();
  }
  
  @override
  Future<AbroadUserLoginModel> checkUserExists(String email) {
    return remote.checkUserExists(email);
  }
}
