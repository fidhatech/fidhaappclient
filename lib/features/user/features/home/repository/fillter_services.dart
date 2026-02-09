import 'package:dating_app/core/network/http/dio_client.dart';
import 'package:dio/dio.dart';

class FilterServices {
  final Dio _dioClient = DioClient.instance;

  Future<List<String>> getLanguages() async {
    try {
      final response = await _dioClient.get('user/languages');
      if (response.data == null || response.data['languages'] == null) {
        return [];
      }
      return List<String>.from(response.data['languages']);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
