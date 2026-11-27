import 'dart:async';

import 'package:eatik_app/core/router/app_routes.dart';
import 'package:eatik_app/core/widgets/async_value_view.dart';
import 'package:eatik_app/core/widgets/state_message.dart';
import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:eatik_app/features/menu/presentation/menu_labels.dart';
import 'package:eatik_app/features/menu/presentation/providers/favorit_menu_provider.dart';
import 'package:eatik_app/features/menu/presentation/providers/menu_filter_provider.dart';
import 'package:eatik_app/features/menu/presentation/providers/menu_list_provider.dart';
import 'package:eatik_app/features/menu/presentation/widgets/antrian_chip.dart';
import 'package:eatik_app/features/menu/presentation/widgets/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MenuPage extends ConsumerStatefulWidget {
  const MenuPage({this.kategoriAwal, super.key});

  /// Dari query parameter, misalnya /menu?kategori=minuman.
  final KategoriMenu? kategoriAwal;

  @override
  ConsumerState<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> {
  @override
  void initState() {
    super.initState();
    _terapkanKategoriAwal();
  }

  @override
  void didUpdateWidget(MenuPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.kategoriAwal != widget.kategoriAwal) {
      _terapkanKategoriAwal();
    }
  }

  void _terapkanKategoriAwal() {
    final kategori = widget.kategoriAwal;
    if (kategori == null) return;

    // Provider tidak boleh diubah saat widget sedang dibangun,
    // jadi ditunda sampai frame selesai.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(menuFilterProvider.notifier).pilihKategori(kategori);
    });
  }

  @override
  Widget build(BuildContext context) {
    final menus = ref.watch(menuListProvider);

    ref.listen(favoritMenuProvider, (previous, next) {
      final bertambah = next.length > (previous?.length ?? 0);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            content: Text(
              bertambah ? 'Ditambahkan ke favorit' : 'Dihapus dari favorit',
            ),
          ),
        );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Eatik'),
        actions: const [AntrianChip()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            unawaited(context.pushNamed<void>(AppRoute.menuTambah)),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (value) =>
                  ref.read(menuFilterProvider.notifier).ubahKataKunci(value),
              decoration: InputDecoration(
                hintText: 'Cari menu...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const _KategoriChips(),
          if (menus.isLoading && menus.hasValue)
            const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: RefreshIndicator(
              onRefresh: ref.read(menuListProvider.notifier).muatUlang,
              child: AsyncValueView<List<Menu>>(
                value: menus,
                isEmpty: (daftar) => daftar.isEmpty,
                empty: const StateMessage(
                  icon: Icons.search_off_rounded,
                  title: 'Menu tidak ditemukan',
                  message: 'Coba kata kunci atau kategori lain.',
                ),
                onRetry: () => ref.invalidate(menuListProvider),
                builder: (daftar) => ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
                  itemCount: daftar.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final menu = daftar[index];
                    return MenuCard(
                      menu: menu,
                      onTap: () => unawaited(
                        context.pushNamed<void>(
                          AppRoute.menuDetail,
                          pathParameters: {'id': menu.id.toString()},
                          extra: menu,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KategoriChips extends ConsumerWidget {
  const _KategoriChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final terpilih = ref.watch(
      menuFilterProvider.select((filter) => filter.kategori),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          for (final kategori in [null, ...KategoriMenu.values])
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(kategori?.label ?? 'Semua'),
                selected: terpilih == kategori,
                onSelected: (_) => ref
                    .read(menuFilterProvider.notifier)
                    .pilihKategori(kategori),
              ),
            ),
        ],
      ),
    );
  }
}
