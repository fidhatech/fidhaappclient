import 'package:injectable/injectable.dart';

import '../../domain/entities/verify_otp_response.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../datasources/authentication_datasource.dart';

@Injectable(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {

  final AuthenticationDatasource _datasource;

  const AuthenticationRepositoryImpl(this._datasource);

  @override
  Future<VerifyOtpResponse> verifyOtp(String phone, String otp) async {
    try {
      final res = await _datasource.verifyOtp(phone: phone, otp: otp);
      return VerifyOtpResponse(
        message: res.message,
        isExistingUser: res.isExistingUser,
        userStage: res.userStage,
        accessToken: res.tokens.accessToken,
        refreshToken: res.tokens.refreshToken,
      );
    } catch (e) {
      rethrow;
    }
  }
}