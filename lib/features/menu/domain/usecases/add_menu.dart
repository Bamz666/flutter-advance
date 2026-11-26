import 'package:eatik_app/core/error/failure.dart';
import 'package:eatik_app/core/error/result.dart';
import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:eatik_app/features/menu/domain/repositories/menu_repository.dart';

class AddMenu {
  const AddMenu(this._repository);

  final MenuRepository _repository;

  Future<Result<Menu>> call({
    required String nama,
    required double harga,
    required KategoriMenu kategori,
    required StatusMenu status,
    String? deskripsi,
  }) async {
    final namaBersih = nama.trim();

    if (namaBersih.isEmpty) {
      return const Failed(ValidationFailure('Nama menu wajib diisi.'));
    }
    if (harga <= 0) {
      return const Failed(ValidationFailure('Harga harus lebih dari 0.'));
    }

    final catatan = deskripsi?.trim();
    return _repository.addMenu(
      nama: namaBersih,
      harga: harga,
      kategori: kategori,
      status: status,
      deskripsi: (catatan == null || catatan.isEmpty) ? null : catatan,
    );
  }
}
