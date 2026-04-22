import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dating_app/core/constants/api_constants.dart';
import 'package:dating_app/core/models/app_update_config_model.dart';

class AppUpdateService {
  final Dio _dio;
  static const String _tag = '[AppUpdateService]';
  static const String _endpoint = '${ApiConstants.apiUrl}user/app-update/config';

  AppUpdateService(this._dio);

  /// Fetches the app update configuration from the server
  /// This is called when the app starts to check if an update is required
  Future<AppUpdateConfig> fetchAppUpdateConfig() async {
    try {
      log('$_tag Fetching app update config...');
      final response = await _dio.get(_endpoint);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('$_tag App update config fetched successfully');
        final config = AppUpdateConfig.fromJson(response.data);
        return config;
      } else {
        log('$_tag Request failed: ${response.statusCode}');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to fetch app update config',
        );
      }
    } catch (e) {
      log('$_tag Error fetching app update config: $e');
      // Return default config on error (disabled)
      return AppUpdateConfig(
        isEnabled: false,
        minimumVersion: '1.0.0',
        currentVersion: '1.0.0',
        appStoreLink: '',
        playStoreLink: '',
        updateMessage: 'Please update the app to continue',
        isForceUpdate: false,
      );
    }
  }
}
