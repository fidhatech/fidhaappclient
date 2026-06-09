import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../features/authentication/data/models/verify_otp_response/verify_otp_response_model.dart';
import '../../constants/api_constants.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: ApiConstants.apiUrl)
abstract class RestClient {

  factory RestClient(Dio dio) = _RestClient;

  @POST('user/auth/otp/verify')
  Future<VerifyOtpResponseModel> verifyOtp({required String phone, required String otp});
}