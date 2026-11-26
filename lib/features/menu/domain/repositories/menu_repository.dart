import 'package:eatik_app/core/error/result.dart';
import 'package:eatik_app/features/menu/domain/entities/menu.dart';

abstract interface class MenuRepository {
  Future<Result<List<Menu>>> getMenus({String? nama, KategoriMenu? kategori});

  Future<Result<Menu>> addMenu({
    required String nama,
    required double harga,
    required KategoriMenu kategori,
    required StatusMenu status,
    String? deskripsi,
  });

  Future<Result<void>> deleteMenu(int id);
}
