import 'package:injectable/injectable.dart';

import '../../../../../core/network/rest/rest_client.dart';
import '../../models/verify_otp_response/verify_otp_response_model.dart';
import '../authentication_datasource.dart';

@Injectable(as: AuthenticationDatasource)
class AuthenticationDatasourceImpl implements AuthenticationDatasource {

  final RestClient _restClient;

  const AuthenticationDatasourceImpl(this._restClient);

  @override
  Future<VerifyOtpResponseModel> verifyOtp({required String phone, required String otp}) async {
    try {
      return await _restClient.verifyOtp(phone: phone, otp: otp);
    } catch (e) {
      rethrow;
    }
  }
}