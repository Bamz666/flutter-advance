import 'package:eatik_app/core/error/result.dart';
import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:eatik_app/features/menu/domain/repositories/menu_repository.dart';

/// Repository palsu yang selalu mengembalikan hasil yang ditentukan.
class FakeMenuRepository implements MenuRepository {
  const FakeMenuRepository(this.hasil);

  final Result<List<Menu>> hasil;

  @override
  Future<Result<List<Menu>>> getMenus({String? nama, KategoriMenu? kategori}) {
    return Future.value(hasil);
  }
}
