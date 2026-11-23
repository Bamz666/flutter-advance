import 'dart:async';

import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:eatik_app/features/menu/presentation/providers/favorit_menu_provider.dart';
import 'package:eatik_app/features/menu/presentation/providers/menu_filter_provider.dart';
import 'package:eatik_app/features/menu/presentation/providers/menu_list_provider.dart';
import 'package:eatik_app/features/menu/presentation/providers/menu_list_state.dart';
import 'package:eatik_app/features/menu/presentation/widgets/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuPage extends ConsumerWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuState = ref.watch(menuListProvider);

    // ref.listen: efek samping (SnackBar) tanpa rebuild.
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
      appBar: AppBar(title: const Text('Menu Eatik')),
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
          Expanded(child: _DaftarMenu(state: menuState)),
        ],
      ),
    );
  }
}

/// Consumer terpisah dengan select: hanya chip yang di-rebuild
/// saat kategori berubah.
class _KategoriChips extends ConsumerWidget {
  const _KategoriChips();

  String _label(KategoriMenu? kategori) {
    return switch (kategori) {
      null => 'Semua',
      KategoriMenu.makanan => 'Makanan',
      KategoriMenu.minuman => 'Minuman',
    };
  }

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
                label: Text(_label(kategori)),
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

class _DaftarMenu extends ConsumerWidget {
  const _DaftarMenu({required this.state});

  final MenuListState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.sedangMemuat && state.menus.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final pesan = state.pesanError;
    if (pesan != null) {
      return _PesanError(
        pesan: pesan,
        onCobaLagi: () =>
            unawaited(ref.read(menuListProvider.notifier).muatUlang()),
      );
    }

    if (state.menus.isEmpty) {
      return const Center(child: Text('Menu tidak ditemukan'));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: state.menus.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => MenuCard(menu: state.menus[index]),
    );
  }
}

class _PesanError extends StatelessWidget {
  const _PesanError({required this.pesan, required this.onCobaLagi});

  final String pesan;
  final VoidCallback onCobaLagi;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 48, color: scheme.outline),
            const SizedBox(height: 16),
            Text(pesan, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: onCobaLagi,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
