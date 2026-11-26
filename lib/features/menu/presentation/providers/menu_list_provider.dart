import 'package:eatik_app/core/error/failure.dart';
import 'package:eatik_app/core/error/result.dart';
import 'package:eatik_app/features/menu/di/menu_dependencies.dart';
import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:eatik_app/features/menu/presentation/providers/menu_filter_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuListNotifier extends AsyncNotifier<List<Menu>> {
  @override
  Future<List<Menu>> build() async {
    final filter = ref.watch(menuFilterProvider);
    final getMenus = ref.watch(getMenusProvider);

    final hasil = await getMenus(
      nama: filter.kataKunci,
      kategori: filter.kategori,
    );

    return switch (hasil) {
      Success(:final data) => data,
      Failed(:final failure) => throw failure,
    };
  }

  Future<void> muatUlang() async {
    ref.invalidateSelf();
    try {
      await future;
    } on Object {
      // Kegagalan sudah tercermin pada state (AsyncError).
    }
  }

  /// Mengembalikan null bila berhasil, atau Failure bila gagal.
  Future<Failure?> tambah({
    required String nama,
    required double harga,
    required KategoriMenu kategori,
    required StatusMenu status,
    String? deskripsi,
  }) async {
    final hasil = await ref.read(addMenuProvider)(
      nama: nama,
      harga: harga,
      kategori: kategori,
      status: status,
      deskripsi: deskripsi,
    );
    return _setelahAksi(hasil);
  }

  Future<Failure?> hapus(int id) async {
    final hasil = await ref.read(deleteMenuProvider)(id);
    return _setelahAksi(hasil);
  }

  /// Bila aksi berhasil, daftar dimuat ulang dari server.
  Failure? _setelahAksi<T>(Result<T> hasil) {
    switch (hasil) {
      case Success():
        if (ref.mounted) ref.invalidateSelf();
        return null;
      case Failed(:final failure):
        return failure;
    }
  }
}

final menuListProvider =
    AsyncNotifierProvider.autoDispose<MenuListNotifier, List<Menu>>(
      MenuListNotifier.new,
    );
