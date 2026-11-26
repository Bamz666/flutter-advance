import 'package:eatik_app/core/error/failure.dart';
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

  @override
  Future<Result<Menu>> addMenu({
    required String nama,
    required double harga,
    required KategoriMenu kategori,
    required StatusMenu status,
    String? deskripsi,
  }) {
    return Future.value(
      Failed(const UnknownFailure('Tidak didukung oleh fake.')),
    );
  }

  @override
  Future<Result<void>> deleteMenu(int id) {
    return Future.value(const Success<void>(null));
  }
}
