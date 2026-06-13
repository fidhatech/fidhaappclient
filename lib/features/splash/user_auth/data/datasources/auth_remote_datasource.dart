import 'dart:developer';

import '../models/auth_response_model.dart';
import 'package:dio/dio.dart';

import '../models/abroad_user_login_model.dart';

class AuthRemoteDatasource {
  final Dio dio;

  const AuthRemoteDatasource(this.dio);

  Future<AbroadUserLoginModel> checkUserExists(String email) async {
    try {
      final response = await dio.post(
        'user/auth/check-user-existence',
        data: {'email': email},
      );
      log(response.data.toString());
      return AbroadUserLoginModel.fromJson(response.data);
    } on DioException catch (e) {
      log(e.response?.data.toString() ?? 'Failed to check user existence');
      throw Exception(e.response?.data['message'] ?? 'Failed to check user existence');
    } catch (e) {
      log(e.toString());
      throw Exception('Something went wrong');
    }
  }


  Future<String> sendOtp(String phone) async {
    try {
      final response = await dio.post(
        'user/auth/otp/send',
        data: {'phoneNumber': phone},
      );
      log(response.data.toString());
      return response.data['message'];
    } on DioException catch (e) {
      log(e.response?.data.toString() ?? 'Failed to send OTP');
      throw Exception(e.response?.data['message'] ?? 'Failed to send OTP');
    } catch (e) {
      log(e.toString());
      throw Exception('Something went wrong');
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
        'user/auth/otp/resend',

        data: {'phoneNumber': phone},
      );

      return response.data['message'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to resend OTP');
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }

  Future<String> deleteUser() async {
    try {
      final response = await dio.delete('user/auth/delete');
      return response.data['message'];
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }
}
