import 'package:eatik_app/core/error/result.dart';
import 'package:eatik_app/core/network/safe_api_call.dart';
import 'package:eatik_app/core/storage/token_storage.dart';
import 'package:eatik_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:eatik_app/features/auth/domain/entities/auth_session.dart';
import 'package:eatik_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote, this._tokenStorage);

  final AuthRemoteDataSource _remote;
  final TokenStorage _tokenStorage;

  @override
  Future<Result<AuthSession>> register({
    required String nama,
    required String username,
    required String password,
  }) {
    return safeApiCall(() async {
      final model = await _remote.register(
        nama: nama,
        username: username,
        password: password,
      );
      return AuthSession(username: model.username, nama: model.nama);
    });
  }

  @override
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  }) {
    return safeApiCall(() async {
      final model = await _remote.login(username: username, password: password);

      final akses = model.accessToken;
      final refresh = model.refreshToken;
      if (akses == null || refresh == null) {
        throw const FormatException('Token tidak ada pada respons login.');
      }

      await _tokenStorage.saveTokens(accessToken: akses, refreshToken: refresh);
      return AuthSession(username: model.username, nama: model.nama);
    });
  }

  @override
  Future<void> logout() async {
    try {
      await _remote.logout();
    } on Object {
      // Server tidak terjangkau: token lokal tetap dihapus di bawah.
    }
    await _tokenStorage.clear();
  }

  @override
  Future<bool> hasSession() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    return refreshToken != null;
  }
}
