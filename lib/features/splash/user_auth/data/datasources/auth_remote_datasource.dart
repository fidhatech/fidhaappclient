import 'dart:developer';

import 'package:dating_app/features/splash/user_auth/data/models/auth_response_model.dart';
import 'package:dio/dio.dart';

class AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasource(this.dio);

  Future<String> sendOtp(String phone) async {
    try {
      final response = await dio.post(
        "user/auth/otp/send",
        data: {"phoneNumber": phone},
      );
      log(response.data.toString());
      return response.data["message"];
    } on DioException catch (e) {
      log(e.response?.data.toString() ?? "Failed to send OTP");
      throw Exception(e.response?.data["message"] ?? "Failed to send OTP");
    } catch (e) {
      log(e.toString());
      throw Exception("Something went wrong");
    }
  }

  Future<VerifyOtpResponse> verifyOtp(String phone, String otp) async {
    try {
      final response = await dio.post(
        'user/auth/otp/verify',
        data: {'phoneNumber': phone, 'otp': otp},
      );
      log(response.data.toString());
      return VerifyOtpResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'OTP verification failed');
    }
  }

  Future<String> resendOtp(String phone) async {
    try {
      final response = await dio.post(
        "user/auth/otp/resend",

        data: {"phoneNumber": phone},
      );

      return response.data["message"];
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Failed to resend OTP");
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  Future<String> deleteUser() async {
    try {
      final response = await dio.delete("user/auth/delete");
      return response.data["message"];
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }
}
