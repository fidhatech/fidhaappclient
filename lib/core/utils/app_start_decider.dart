import 'dart:developer';

import 'package:injectable/injectable.dart';

import '../network/http/dio_client.dart';
import '../services/secure_storage.dart';
import 'logger.dart';

enum AppStartStatus { onboarding, client, employee }

@singleton
class AppStartDecider {

  final SecureStorage _storage;

  const AppStartDecider(this._storage);

  Future<AppStartStatus> determineStartStatus() async {
    logger.i('🚀 AppStartDecider: Starting determineStartStatus');

    // 1️⃣ No tokens → not logged in
    final hasTokens = await _storage.hasTokens();
    logger.i('🚀 AppStartDecider: hasTokens result: $hasTokens');
    if (!hasTokens) return AppStartStatus.onboarding;

    // 2️⃣ Check Local Role (Offline Support)
    final localRole = await _storage.getUserRole();
    if (localRole != null) {
      logger.i('[APP_START][LOCAL] Found persisted role: $localRole');

      // Fire-and-forget background validation
      _validateSessionInBackground();

      if (localRole == 'client') {
        return AppStartStatus.client;
      } else if (localRole == 'employee') {
        return AppStartStatus.employee;
      }
    }

    // 3️⃣ Network Check (Fallback if no local role or fresh install)
    logger.i('[APP_START][NETWORK] No local role. Fetching from server...');
    try {
      // 2️⃣ Check Role directly
      // user/check-role returns { isClient: bool, isEmployee: bool }
      logger.i('🚀 AppStartDecider: Requesting user/check-role...');

      // Force timeout of 5 seconds for this check
      final response = await DioClient.instance
          .get('user/check-role')
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              throw Exception('Connection timed out');
            },
          );

      logger.i('🚀 AppStartDecider: Response received');
      final data = response.data;
      logger.i('🚀 AppStartDecider: Data: $data');

      if (data['isClient'] == true) {
        logger.i('[APP_START] User is Client. Saving role and proceeding.');
        await _storage.saveUserRole('client');
        return AppStartStatus.client;
      } else if (data['isEmployee'] == true) {
        logger.i('[APP_START] User is Employee. Saving role and proceeding.');
        await _storage.saveUserRole('employee');
        return AppStartStatus.employee;
      } else {
        log(
          '[APP_START] Role Undetermined from server. Fallback to Onboarding.',
        );
        return AppStartStatus.onboarding;
      }
    } catch (e, s) {
      logger.e('❌ AppStartDecider Error: $e', stackTrace: s);
      // Refresh failed, tokens invalid, or network error
      return AppStartStatus.onboarding;
    }
  }

  Future<void> _validateSessionInBackground() async {
    await fetchAndSaveRole();
  }

  /// Public method to force-fetch and save the user role.
  /// Call this after login or when role might have changed.
  Future<void> fetchAndSaveRole() async {
    try {
      logger.i('[APP_START][BACKGROUND] Validating/Fetching session...');
      final response = await DioClient.instance.get('user/check-role');
      final data = response.data;

      if (data['isClient'] == true) {
        logger.i('[APP_START] Saved role: client');
        await _storage.saveUserRole('client');
      } else if (data['isEmployee'] == true) {
        logger.i('[APP_START] Saved role: employee');
        await _storage.saveUserRole('employee');
      } else {
        logger.i('[APP_START] Role check returned indeterminate result.');
      }
    } catch (e, s) {
      logger.e('[APP_START][BACKGROUND] Role fetch warning: $e', stackTrace: s);
      // Note: DioClient handles 401 logs out automatically.
    }
  }
}
