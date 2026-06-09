import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../utils/logger.dart';

@lazySingleton
class SecureStorage {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  final _keyAccessToken = 'access_token';
  final _keyRefreshToken = 'refresh_token';

  final _keyRole = 'role';
  final _keyProfileStatus = 'profile_status';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    logger.i('🔐 SecureStorage: saving tokens...');
    await Future.wait([
      _storage.write(key: _keyAccessToken, value: accessToken),
      _storage.write(key: _keyRefreshToken, value: refreshToken),
    ]);
    logger.i('🔐 SecureStorage: tokens saved.');
  }

  Future<void> saveUserRole(String role) async {
    logger.i('🔐 SecureStorage: saving role: $role');
    await _storage.write(key: _keyRole, value: role);
  }

  Future<String?> getUserRole() async {
    logger.i('🔐 SecureStorage: reading role...');
    final role = await _storage.read(key: _keyRole);
    return role;
  }

  // Profile Status
  Future<void> saveProfileStatus(String status) async {
    await _storage.write(key: _keyProfileStatus, value: status);
  }

  Future<String?> getProfileStatus() async {
    return await _storage.read(key: _keyProfileStatus);
  }

  // FCM Token
  Future<void> saveFcmToken(String token) async {
    await _storage.write(key: 'fcm_token', value: token);
  }

  Future<String?> getFcmToken() async {
    return await _storage.read(key: 'fcm_token');
  }

  Future<String?> getAccessToken() async {
    logger.i('🔐 SecureStorage: reading access token...');
    final token = await _storage.read(key: _keyAccessToken);
    logger.i('🔐 SecureStorage: access token read end.');
    return token;
  }

  Future<String?> getRefreshToken() =>
      _storage.read(key: _keyRefreshToken);

  Future<bool> hasTokens() async {
    logger.i('🔐 SecureStorage: checking hasTokens...');
    final access = await getAccessToken();
    logger.i('🔐 SecureStorage: access token checked: ${access != null}');
    final refresh = await getRefreshToken();
    logger.i('🔐 SecureStorage: refresh token checked: ${refresh != null}');
    return access != null && refresh != null;
  }

  Future<void> clearAll() async {
    logger.i('🔐 SecureStorage: Clearing ALL data...');
    await _storage.deleteAll();
    logger.i('🔐 SecureStorage: ALL data cleared.');
  }

  // Deprecated: verify usage and replace with clearAll where appropriate
  Future<void> clearTokens() async {
    await clearAll();
  }
}
