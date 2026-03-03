import 'dart:async';
import 'dart:developer';

import 'package:dating_app/features/employee/constants/employee_constants.dart';
import 'package:dating_app/core/constants/api_constants.dart';
import 'package:dating_app/core/globals/keys.dart';
import 'package:dating_app/core/storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  static Dio? _dio;
  static bool _isRefreshing = false;
  static final List<Function(String)> _refreshQueue = [];

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.apiUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Add PrettyDioLogger
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await SecureStorage.getAccessToken();

          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          handler.next(options);
        },

        onResponse: (response, handler) {
          handler.next(response);
        },

        /// ERROR HANDLING
        onError: (DioException error, handler) async {
          // Handle Network/Connection Errors globally
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError ||
              error.error.toString().contains('SocketException')) {
            String message =
                "No Internet Connection. Please turn on mobile data or Wi-Fi.";
            IconData icon = Icons.wifi_off;

            if (error.type == DioExceptionType.receiveTimeout ||
                error.type == DioExceptionType.sendTimeout ||
                error.type == DioExceptionType.connectionTimeout) {
              message = "Server took too long to respond. Please try again.";
              icon = Icons.timer_outlined;
            }

            // Show global customized SnackBar
            rootScaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(icon, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 4),
                margin: const EdgeInsets.all(16),
                action: SnackBarAction(
                  label: 'OK',
                  textColor: Colors.white,
                  onPressed: () {
                    rootScaffoldMessengerKey.currentState
                        ?.hideCurrentSnackBar();
                  },
                ),
              ),
            );
          }

          if (error.response?.statusCode == 401) {
            final refreshToken = await SecureStorage.getRefreshToken();

            if (refreshToken == null) {
              await SecureStorage.clearTokens();
              return handler.reject(error);
            }

            // If refresh already in progress → wait
            if (_isRefreshing) {
              final completer = Completer<Response>();

              _refreshQueue.add((newToken) async {
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newToken';
                final response = await _dio!.fetch(error.requestOptions);
                completer.complete(response);
              });

              return handler.resolve(await completer.future);
            }

            _isRefreshing = true;
            log('🔄 Session expired (401). Attempting token refresh...');

            try {
              final role = await SecureStorage.getUserRole();
              log('🔄 Detected role: $role');

              // Select correct refresh endpoint based on role
              String refreshUrl = 'user/auth/refresh';
              if (role == 'employee') {
                refreshUrl = EmployeeConstants.endpointRefresh;
              }
              log('🔄 Using refresh endpoint: $refreshUrl');

              final refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.apiUrl));

              // Add logger to refreshDio as well for debugging purposes
              refreshDio.interceptors.add(
                PrettyDioLogger(
                  requestHeader: true,
                  requestBody: true,
                  responseBody: true,
                  responseHeader: false,
                  error: true,
                  compact: true,
                  maxWidth: 90,
                ),
              );

              final refreshResponse = await refreshDio.post(
                refreshUrl,
                data: {'refreshToken': refreshToken},
              );

              final newAccessToken =
                  refreshResponse.data['tokens']['accessToken'];
              final newRefreshToken =
                  refreshResponse.data['tokens']['refreshToken'];

              await SecureStorage.saveTokens(
                accessToken: newAccessToken,
                refreshToken: newRefreshToken,
              );

              log('✅ Token refresh successful. retrying original request.');

              // 🔓 Release waiting requests
              for (final queued in _refreshQueue) {
                queued(newAccessToken);
              }
              _refreshQueue.clear();

              // Retry original request
              error.requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';
              return handler.resolve(await _dio!.fetch(error.requestOptions));
            } catch (e) {
              log('❌ Token refresh failed: $e');
              await SecureStorage.clearTokens();
              return handler.reject(error);
            } finally {
              _isRefreshing = false;
            }
          }

          handler.next(error);
        },
      ),
    );

    return dio;
  }
}
