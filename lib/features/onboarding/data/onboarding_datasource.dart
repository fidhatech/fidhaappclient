import 'dart:developer';

import 'package:dio/dio.dart';

class OnboardingDatasource {

  final Dio dio;

  OnboardingDatasource(this.dio);

  Future<void> submitAbroadUserDetails({
    required String email,
    required String name,
    required String phone,
  }) async {
    try {
      final response = await dio.post(
        "user/onboarding/submit-details",
        data: {
          "email": email,
          "name": name,
          "phone": phone,
        },
      );
      log(response.data.toString());
    } on DioException catch (e) {
      log(e.response?.data.toString() ?? "Failed to submit user details");
      throw Exception(e.response?.data["message"] ?? "Failed to submit user details");
    } catch (e) {
      log(e.toString());
      throw Exception("Something went wrong");
    }
  }
}