import 'package:eatik_app/features/menu/domain/entities/menu.dart';

abstract interface class MenuRepository {
  Future<List<Menu>> getMenus({String? nama, KategoriMenu? kategori});
}
