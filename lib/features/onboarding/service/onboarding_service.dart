import 'dart:developer';

import 'package:dio/dio.dart';

class OnboardingService {
  final Dio _dio;
  OnboardingService(this._dio);

  Future<Map<String, dynamic>> roleCheck() async {
    try {
      final data = await _dio.get("user/check-role");
      return data.data;
    } on DioException catch (e) {
      log("dio ${e.toString()}");
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future sendOnboardData(Map<String, dynamic> payload) async {
    try {
      await _dio.patch("user/home/onboard", data: payload);
    } on DioException catch (e) {
      log("dio ${e.toString()}");
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getLanguages() async {
    try {
      var response = await _dio.get("user/languages");
      log(response.data.toString());
      return response.data;
    } on DioException catch (e) {
      log("dio ${e.toString()}");
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchAudioVerificationText({
    required String language,
  }) async {
    try {
      final response = await _dio.post(
        "user/audio-verification/text",
        data: {"language": language},
      );

      log("Audio Verification Response: ${response.data}");
      return response.data;
    } on DioException catch (e) {
      log("Audio Verification Error: ${e.response?.data}");
      rethrow;
    }
  }

  Future<Map<String, String>> sendOnboardEmployeeData(
    Map<String, dynamic> payload,
  ) async {
    try {
      FormData formData = FormData.fromMap(payload, ListFormat.multiCompatible);
      log(formData.toString());

      final response = await _dio.patch(
        "employee/profile/onboard",
        data: formData,
      );
      log(response.data.toString());

      log("Onboarding Success: ${response.data}");
      return (response.data['tokens']).cast<String, String>();
    } on DioException catch (e) {
      log("Dio Error Data: ${e.response?.data}");
      log("Dio Error Msg: ${e.message}");
      log("Dio Error: ${e.response?.data ?? e.message}");
      rethrow;
    } catch (e) {
      log("Unexpected Error: ${e.toString()}");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> checkVerificationStatus(
    Map<String, dynamic> userInfo,
  ) async {
    try {
      final response = await _dio.get(
        "employee/profile/verification-status",
        data: userInfo,
      );
      log("resposen data ${response.data}");
      return response.data['data'];
    } on DioException catch (e) {
      log("Verification Check Error: ${e.toString()}");
      rethrow;
    }
  }

  Future<bool> primeImageUpload(List<String> images) async {
    try {
      final payload = FormData();

      for (final image in images) {
        log(image);
        payload.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(
              image,
              filename: image.split('/').last,
            ),
          ),
        );
      }

      final response = await _dio.patch(
        "employee/profile/prime/activate",
        data: payload,
      );
      log(response.toString());
      if (response.statusCode == 200) {
        log("${response.data} ${response.statusCode}");

        return true;
      } else {
        log("${response.data} ${response.statusCode}");
        throw Exception({response.statusMessage});
      }
    } catch (e) {
      log("Upload failed: $e");
      return false;
    }
  }
}
