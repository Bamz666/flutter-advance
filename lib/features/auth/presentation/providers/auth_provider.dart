import 'package:eatik_app/core/error/failure.dart';
import 'package:eatik_app/core/error/result.dart';
import 'package:eatik_app/core/network/session_expired_provider.dart';
import 'package:eatik_app/features/auth/di/auth_dependencies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State: true bila pengguna sudah masuk.
class AuthNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    // Sesi berakhir (refresh token gagal): kembali ke halaman masuk.
    ref.listen(sessionExpiredProvider, (previous, next) {
      state = const AsyncData(false);
    });

    return ref.watch(checkSessionProvider)();
  }

  /// Mengembalikan null bila berhasil, atau Failure bila gagal.
  Future<Failure?> masuk({
    required String username,
    required String password,
  }) async {
    final hasil = await ref.read(loginProvider)(
      username: username,
      password: password,
    );

    switch (hasil) {
      case Success():
        state = const AsyncData(true);
        return null;
      case Failed(:final failure):
        return failure;
    }
  }

  Future<Failure?> daftar({
    required String nama,
    required String username,
    required String password,
  }) async {
    final hasil = await ref.read(registerProvider)(
      nama: nama,
      username: username,
      password: password,
    );

    switch (hasil) {
      case Success():
        return masuk(username: username, password: password);
      case Failed(:final failure):
        return failure;
    }
  }

  Future<void> keluar() async {
    await ref.read(logoutProvider)();
    state = const AsyncData(false);
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, bool>(
  AuthNotifier.new,
);
