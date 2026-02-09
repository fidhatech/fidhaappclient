// lib/core/services/secure_storage.dart
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';

  static const _keyRole = 'role';
  static const _keyProfileStatus = 'profile_status';

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    log("🔐 SecureStorage: saving tokens...");
    await Future.wait([
      _storage.write(key: _keyAccessToken, value: accessToken),
      _storage.write(key: _keyRefreshToken, value: refreshToken),
    ]);
    log("🔐 SecureStorage: tokens saved.");
  }

  static Future<void> saveUserRole(String role) async {
    print("🔐 SecureStorage: saving role: $role");
    await _storage.write(key: _keyRole, value: role);
  }

  static Future<String?> getUserRole() async {
    print("🔐 SecureStorage: reading role...");
    final role = await _storage.read(key: _keyRole);
    return role;
  }

  // Profile Status
  static Future<void> saveProfileStatus(String status) async {
    await _storage.write(key: _keyProfileStatus, value: status);
  }

  static Future<String?> getProfileStatus() async {
    return await _storage.read(key: _keyProfileStatus);
  }

  // FCM Token
  static Future<void> saveFcmToken(String token) async {
    await _storage.write(key: 'fcm_token', value: token);
  }

  static Future<String?> getFcmToken() async {
    return await _storage.read(key: 'fcm_token');
  }

  static Future<String?> getAccessToken() async {
    log("🔐 SecureStorage: reading access token...");
    final token = await _storage.read(key: _keyAccessToken);
    log("🔐 SecureStorage: access token read end.");
    return token;
  }

  static Future<String?> getRefreshToken() =>
      _storage.read(key: _keyRefreshToken);

  static Future<bool> hasTokens() async {
    log("🔐 SecureStorage: checking hasTokens...");
    final access = await getAccessToken();
    log("🔐 SecureStorage: access token checked: ${access != null}");
    final refresh = await getRefreshToken();
    log("🔐 SecureStorage: refresh token checked: ${refresh != null}");
    return access != null && refresh != null;
  }

  static Future<void> clearAll() async {
    log("🔐 SecureStorage: Clearing ALL data...");
    await _storage.deleteAll();
    log("🔐 SecureStorage: ALL data cleared.");
  }

  // Deprecated: verify usage and replace with clearAll where appropriate
  static Future<void> clearTokens() async {
    await clearAll();
  }
}
