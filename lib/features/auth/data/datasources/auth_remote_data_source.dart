import 'package:eatik_app/features/auth/data/models/auth_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthResponseModel> register({
    required String nama,
    required String username,
    required String password,
  });

  Future<AuthResponseModel> login({
    required String username,
    required String password,
  });

  Future<void> logout();
}
