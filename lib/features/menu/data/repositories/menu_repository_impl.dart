import 'package:eatik_app/core/error/result.dart';
import 'package:eatik_app/core/network/safe_api_call.dart';
import 'package:eatik_app/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:eatik_app/features/menu/domain/repositories/menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  const MenuRepositoryImpl(this._remoteDataSource);

  final MenuRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<Menu>>> getMenus({String? nama, KategoriMenu? kategori}) {
    return safeApiCall(() async {
      final models = await _remoteDataSource.fetchMenus(
        nama: nama,
        // Nama enum 'makanan' menjadi 'MAKANAN' sesuai nilai pada API.
        kategori: kategori?.name.toUpperCase(),
      );
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Result<Menu>> addMenu({
    required String nama,
    required double harga,
    required KategoriMenu kategori,
    required StatusMenu status,
    String? deskripsi,
  }) {
    return safeApiCall(() async {
      final model = await _remoteDataSource.createMenu(
        nama: nama,
        harga: harga,
        kategori: kategori.name.toUpperCase(),
        status: status.name.toUpperCase(),
        deskripsi: deskripsi,
      );
      return model.toEntity();
    });
  }

  @override
  Future<Result<void>> deleteMenu(int id) {
    return safeApiCall(() => _remoteDataSource.deleteMenu(id));
  }
}
