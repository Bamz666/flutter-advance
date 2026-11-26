import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class TokenStorage {
  Future<String?> readAccessToken();

  Future<String?> readRefreshToken();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<void> clear();
}

class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _kunciAkses = 'access_token';
  static const _kunciRefresh = 'refresh_token';

  @override
  Future<String?> readAccessToken() => _storage.read(key: _kunciAkses);

  @override
  Future<String?> readRefreshToken() => _storage.read(key: _kunciRefresh);

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _kunciAkses, value: accessToken);
    await _storage.write(key: _kunciRefresh, value: refreshToken);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _kunciAkses);
    await _storage.delete(key: _kunciRefresh);
  }
}
