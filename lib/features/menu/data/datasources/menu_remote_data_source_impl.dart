import 'package:dio/dio.dart';
import 'package:eatik_app/core/network/api_client.dart';
import 'package:eatik_app/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:eatik_app/features/menu/data/models/menu_model.dart';

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  MenuRemoteDataSourceImpl(this._api);

  final ApiClient _api;
  CancelToken? _cancelToken;

  @override
  Future<List<MenuModel>> fetchMenus({String? nama, String? kategori}) async {
    // Batalkan request sebelumnya yang belum selesai.
    _cancelToken?.cancel('Digantikan oleh permintaan yang lebih baru');
    final token = _cancelToken = CancelToken();

    final response = await _api.get<List<dynamic>>(
      '/menu',
      queryParameters: {
        if (nama != null && nama.isNotEmpty) 'nama': nama,
        if (kategori != null) 'kategori': kategori,
      },
      cancelToken: token,
    );

    final data = response.data ?? const <dynamic>[];
    return data
        .map((item) => MenuModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<MenuModel> createMenu({
    required String nama,
    required double harga,
    required String kategori,
    String? status,
    String? deskripsi,
  }) async {
    final form = FormData.fromMap({
      'nama': nama,
      'harga': harga,
      'kategori': kategori,
      if (deskripsi != null) 'deskripsi': deskripsi,
      if (status != null) 'status': status,
    });

    final response = await _api.post<Map<String, dynamic>>('/menu', data: form);

    final body = response.data;
    if (body == null) throw const FormatException('Respons kosong.');
    return MenuModel.fromJson(body);
  }

  @override
  Future<void> deleteMenu(int id) async {
    await _api.delete<void>('/menu/$id');
  }
}
