import 'package:eatik_app/core/di/core_dependencies.dart';
import 'package:eatik_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:eatik_app/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:eatik_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:eatik_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:eatik_app/features/auth/domain/usecases/check_session.dart';
import 'package:eatik_app/features/auth/domain/usecases/login.dart';
import 'package:eatik_app/features/auth/domain/usecases/logout.dart';
import 'package:eatik_app/features/auth/domain/usecases/register.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(apiClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(tokenStorageProvider),
  );
});

final loginProvider = Provider<Login>((ref) {
  return Login(ref.watch(authRepositoryProvider));
});

final registerProvider = Provider<Register>((ref) {
  return Register(ref.watch(authRepositoryProvider));
});

final logoutProvider = Provider<Logout>((ref) {
  return Logout(ref.watch(authRepositoryProvider));
});

final checkSessionProvider = Provider<CheckSession>((ref) {
  return CheckSession(ref.watch(authRepositoryProvider));
});
