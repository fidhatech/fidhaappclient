import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../constants/api_constants.dart';
import '../../services/secure_storage.dart';

@singleton
class DioProvider {

  final SecureStorage _storage;

  Dio? _dio;

  DioProvider(this._storage);

  Future<Dio> get dio async {
    if (_dio == null) {
      await initialize();
    }

    return _dio!;
  }

  Future<void> initialize() async {
    final options = BaseOptions(
      baseUrl: ApiConstants.apiUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 60),
      contentType: ContentType.json.mimeType,
    );

    _dio = Dio(options);

    // final accessToken = await _storage.getAccessToken();

    // if (accessToken != null) {
    //   _dio!.options.headers['Authorization'] = 'Bearer $accessToken';
    // }

    _dio!.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    _dio!.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken = await _storage.getAccessToken();
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
    ));
  }
}