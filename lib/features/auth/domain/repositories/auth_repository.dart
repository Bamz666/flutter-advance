import 'package:eatik_app/core/error/result.dart';
import 'package:eatik_app/features/auth/domain/entities/auth_session.dart';

abstract interface class AuthRepository {
  Future<Result<AuthSession>> register({
    required String nama,
    required String username,
    required String password,
  });

  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  });

  /// Selalu menghapus token lokal, walaupun server tidak terjangkau.
  Future<void> logout();

  Future<bool> hasSession();
}
