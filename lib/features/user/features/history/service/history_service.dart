import 'dart:developer';
import 'package:dating_app/features/user/features/history/model/history_model.dart';
import 'package:dio/dio.dart';

class HistoryService {
  final Dio _dio;

  HistoryService(this._dio);

  Future<List<History>> fetchHistory() async {
    try {
      final response = await _dio.get("user/call/history");

      final history = response.data['history'] as List;

      return history.map((e) => History.fromJson(e)).toList();
    } on DioException catch (e) {
      log("Dio error: ${e.response?.data ?? e.message}");
      rethrow;
    } catch (e) {
      log("Unexpected error: $e");
      rethrow;
    }
  }
}
