import 'package:eatik_app/features/menu/data/models/menu_model.dart';

abstract interface class MenuRemoteDataSource {
  Future<List<MenuModel>> fetchMenus({String? nama, String? kategori});
}
