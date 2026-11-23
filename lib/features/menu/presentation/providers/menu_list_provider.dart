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
}

final menuListProvider = AsyncNotifierProvider<MenuListNotifier, List<Menu>>(
  MenuListNotifier.new,
);
