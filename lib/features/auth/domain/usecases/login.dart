import 'package:eatik_app/core/error/failure.dart';
import 'package:eatik_app/core/error/result.dart';
import 'package:eatik_app/features/auth/domain/entities/auth_session.dart';
import 'package:eatik_app/features/auth/domain/repositories/auth_repository.dart';

class Login {
  const Login(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthSession>> call({
    required String username,
    required String password,
  }) async {
    final user = username.trim();
    if (user.isEmpty || password.isEmpty) {
      return const Failed(
        ValidationFailure('Username dan password wajib diisi.'),
      );
    }
    return _repository.login(username: user, password: password);
  }
}
