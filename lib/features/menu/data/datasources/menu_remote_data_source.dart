import 'package:eatik_app/features/menu/data/models/menu_model.dart';

abstract interface class MenuRemoteDataSource {
  Future<List<MenuModel>> fetchMenus({String? nama, String? kategori});

  Future<MenuModel> createMenu({
    required String nama,
    required double harga,
    required String kategori,
    String? status,
    String? deskripsi,
  });

  Future<void> deleteMenu(int id);
}
