import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:dating_app/features/employee/history/model/session_model.dart';

class SessionHistory {
  final Dio _dio;

  SessionHistory(this._dio);

  Future<List<SessionModel>> fetchSession() async {
    try {
      final response = await _dio.get("employee/call/sessions");

      if (response.statusCode != 200) {
        throw Exception("Failed to fetch sessions: ${response.statusCode}");
      }

      final sessions = response.data?["data"]?["sessions"];

      if (sessions == null || sessions is! List) {
        throw Exception("Invalid response format");
      }

      return sessions
          .map<SessionModel>((json) => SessionModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      log("Dio error: ${e.response?.data ?? e.message}");
      rethrow;
    } catch (e) {
      log("Unexpected error: $e");
      rethrow;
    }
  }
}
