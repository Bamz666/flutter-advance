import 'package:eatik_app/core/error/failure.dart';
import 'package:eatik_app/core/error/result.dart';
import 'package:eatik_app/features/auth/domain/entities/auth_session.dart';
import 'package:eatik_app/features/auth/domain/repositories/auth_repository.dart';

class Register {
  const Register(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthSession>> call({
    required String nama,
    required String username,
    required String password,
  }) async {
    final namaBersih = nama.trim();
    final user = username.trim();

    if (namaBersih.isEmpty || user.isEmpty) {
      return const Failed(ValidationFailure('Nama dan username wajib diisi.'));
    }
    if (password.length < 6) {
      return const Failed(ValidationFailure('Password minimal 6 karakter.'));
    }
    return _repository.register(
      nama: namaBersih,
      username: user,
      password: password,
    );
  }
}
