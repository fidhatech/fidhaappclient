import 'dart:developer';

import 'package:dating_app/core/network/http/dio_client.dart';
import 'package:dating_app/core/storage/secure_storage.dart';

enum AppStartStatus { onboarding, client, employee }

class AppStartDecider {
  static Future<AppStartStatus> determineStartStatus() async {
    log("🚀 AppStartDecider: Starting determineStartStatus");
    // 1️⃣ No tokens → not logged in
    final hasTokens = await SecureStorage.hasTokens();
    log("🚀 AppStartDecider: hasTokens result: $hasTokens");
    if (!hasTokens) return AppStartStatus.onboarding;

    // 2️⃣ Check Local Role (Offline Support)
    final localRole = await SecureStorage.getUserRole();
    if (localRole != null) {
      log("[APP_START][LOCAL] Found persisted role: $localRole");

      // Fire-and-forget background validation
      _validateSessionInBackground();

      if (localRole == 'client') {
        return AppStartStatus.client;
      } else if (localRole == 'employee') {
        return AppStartStatus.employee;
      }
    }

    // 3️⃣ Network Check (Fallback if no local role or fresh install)
    log("[APP_START][NETWORK] No local role. Fetching from server...");
    try {
      // 2️⃣ Check Role directly
      // user/check-role returns { isClient: bool, isEmployee: bool }
      log("🚀 AppStartDecider: Requesting user/check-role...");

      // Force timeout of 5 seconds for this check
      final response = await DioClient.instance
          .get('user/check-role')
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              throw Exception('Connection timed out');
            },
          );

      log("🚀 AppStartDecider: Response received");
      final data = response.data;
      log("🚀 AppStartDecider: Data: $data");

      if (data['isClient'] == true) {
        log("[APP_START] User is Client. Saving role and proceeding.");
        await SecureStorage.saveUserRole('client');
        return AppStartStatus.client;
      } else if (data['isEmployee'] == true) {
        log("[APP_START] User is Employee. Saving role and proceeding.");
        await SecureStorage.saveUserRole('employee');
        return AppStartStatus.employee;
      } else {
        log(
          "[APP_START] Role Undetermined from server. Fallback to Onboarding.",
        );
        return AppStartStatus.onboarding;
      }
    } catch (e, s) {
      log("❌ AppStartDecider Error: $e");
      log("❌ Stack: $s");
      // Refresh failed, tokens invalid, or network error
      return AppStartStatus.onboarding;
    }
  }

  static Future<void> _validateSessionInBackground() async {
    await fetchAndSaveRole();
  }

  /// Public method to force-fetch and save the user role.
  /// Call this after login or when role might have changed.
  static Future<void> fetchAndSaveRole() async {
    try {
      log("[APP_START][BACKGROUND] Validating/Fetching session...");
      final response = await DioClient.instance.get('user/check-role');
      final data = response.data;

      if (data['isClient'] == true) {
        log("[APP_START] Saved role: client");
        await SecureStorage.saveUserRole('client');
      } else if (data['isEmployee'] == true) {
        log("[APP_START] Saved role: employee");
        await SecureStorage.saveUserRole('employee');
      } else {
        log("[APP_START] Role check returned indeterminate result.");
      }
    } catch (e) {
      log("[APP_START][BACKGROUND] Role fetch warning: $e");
      // Note: DioClient handles 401 logs out automatically.
    }
  }
}
