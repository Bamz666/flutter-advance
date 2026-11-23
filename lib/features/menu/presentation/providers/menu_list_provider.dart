import 'dart:async';

import 'package:eatik_app/core/error/result.dart';
import 'package:eatik_app/features/menu/presentation/providers/menu_filter_provider.dart';
import 'package:eatik_app/features/menu/presentation/providers/menu_list_state.dart';
import 'package:eatik_app/features/menu/presentation/providers/menu_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuListNotifier extends Notifier<MenuListState> {
  // Penanda permintaan terbaru agar hasil permintaan lama diabaikan.
  int _idPermintaan = 0;

  @override
  MenuListState build() {
    // Provider dependency: build ulang otomatis saat filter berubah.
    final filter = ref.watch(menuFilterProvider);
    final id = ++_idPermintaan;
    unawaited(Future.microtask(() => _muat(id, filter)));
    return const MenuListState.awal();
  }

  Future<void> muatUlang() {
    return _muat(++_idPermintaan, ref.read(menuFilterProvider));
  }

  Future<void> _muat(int id, MenuFilter filter) async {
    final getMenus = ref.read(getMenusProvider);
    state = MenuListState.memuat(state.menus);

    final hasil = await getMenus(
      nama: filter.kataKunci,
      kategori: filter.kategori,
    );

    if (!ref.mounted || id != _idPermintaan) return;
    state = switch (hasil) {
      Success(:final data) => MenuListState.berhasil(data),
      Failed(:final failure) => MenuListState.gagal(failure.message),
    };
  }
}

final menuListProvider = NotifierProvider<MenuListNotifier, MenuListState>(
  MenuListNotifier.new,
);
