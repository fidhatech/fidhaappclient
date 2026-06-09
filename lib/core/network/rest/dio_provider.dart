import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../di/di.dart';
import '../../services/secure_storage.dart';

class DioProvider {

  Dio? _dio;

  Future<Dio> get dio async {
    if (_dio == null) {
      await initialize();
    }

    return _dio!;
  }

  Future<void> initialize() async {
    final options = BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 60),
      contentType: ContentType.json.mimeType,
    );

    _dio = Dio(options);

    final accessToken = await getIt.get<SecureStorage>().getAccessToken();

    if (accessToken != null) {
      _dio!.options.headers['Authorization'] = 'Bearer $accessToken';
    }

    _dio!.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
}