import 'package:dio/dio.dart';
import 'package:eatik_app/core/network/api_client.dart';
import 'package:eatik_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:eatik_app/features/auth/data/models/auth_response_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._api);

  final ApiClient _api;

  @override
  Future<AuthResponseModel> register({
    required String nama,
    required String username,
    required String password,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      '/auth/register',
      data: {'username': username, 'password': password, 'nama': nama},
    );
    return _baca(response);
  }

  @override
  Future<AuthResponseModel> login({
    required String username,
    required String password,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'username': username, 'password': password},
    );
    return _baca(response);
  }

  @override
  Future<void> logout() async {
    await _api.post<void>('/auth/logout');
  }

  AuthResponseModel _baca(Response<Map<String, dynamic>> response) {
    final body = response.data;
    if (body == null) throw const FormatException('Respons kosong.');
    return AuthResponseModel.fromJson(body);
  }
}
