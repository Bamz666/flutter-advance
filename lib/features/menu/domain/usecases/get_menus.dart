import 'package:eatik_app/core/error/result.dart';
import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:eatik_app/features/menu/domain/repositories/menu_repository.dart';

class GetMenus {
  const GetMenus(this._repository);

  final MenuRepository _repository;

  Future<Result<List<Menu>>> call({
    String? nama,
    KategoriMenu? kategori,
  }) async {
    final result = await _repository.getMenus(
      nama: nama?.trim(),
      kategori: kategori,
    );

    return switch (result) {
      Success(:final data) => Success(_urutkan(data)),
      Failed() => result,
    };
  }

  List<Menu> _urutkan(List<Menu> daftar) {
    final hasil = [...daftar];
    hasil.sort((a, b) {
      if (a.status != b.status) {
        return a.status == StatusMenu.tersedia ? -1 : 1;
      }
      return a.nama.compareTo(b.nama);
    });
    return hasil;
  }
}
