import 'dart:async';

import 'package:eatik_app/core/utils/rupiah_extension.dart';
import 'package:eatik_app/core/widgets/state_message.dart';
import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:eatik_app/features/menu/presentation/menu_labels.dart';
import 'package:eatik_app/features/menu/presentation/providers/menu_by_id_provider.dart';
import 'package:eatik_app/features/menu/presentation/providers/menu_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MenuDetailPage extends ConsumerWidget {
  const MenuDetailPage({required this.menuId, this.menuAwal, super.key});

  /// Dari path parameter: identitas halaman, ada pada deep link.
  final int menuId;

  /// Dari extra: hanya pelengkap, tidak ada pada deep link.
  final Menu? menuAwal;

  Future<void> _hapus(BuildContext context, WidgetRef ref, Menu menu) async {
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final nama = menu.nama;

    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus menu?'),
        content: Text('Menu "$nama" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin != true) return;

    router.pop();
    final failure = await ref.read(menuListProvider.notifier).hapus(menu.id);
    messenger.showSnackBar(
      SnackBar(content: Text(failure?.message ?? 'Menu dihapus')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memuat = ref.watch(menuListProvider.select((v) => v.isLoading));
    final menu = ref.watch(menuByIdProvider(menuId)) ?? menuAwal;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Menu')),
      body: _isi(context, ref, menu, memuat),
    );
  }

  Widget _isi(BuildContext context, WidgetRef ref, Menu? menu, bool memuat) {
    if (menu == null) {
      if (memuat) return const Center(child: CircularProgressIndicator());
      return StateMessage(
        icon: Icons.search_off_rounded,
        title: 'Menu tidak ditemukan',
        actionLabel: 'Kembali',
        onAction: () => context.pop(),
      );
    }

    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final deskripsi = menu.deskripsi;
    final id = menu.id;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          menu.nama,
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          menu.harga.toRupiah(),
          style: textTheme.titleMedium?.copyWith(
            color: scheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            Chip(label: Text(menu.kategori.label)),
            Chip(label: Text(menu.status.label)),
          ],
        ),
        if (deskripsi != null) ...[
          const SizedBox(height: 16),
          Text(deskripsi, style: textTheme.bodyLarge),
        ],
        const SizedBox(height: 16),
        Text(
          'ID menu: $id',
          style: textTheme.bodySmall?.copyWith(color: scheme.outline),
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () => unawaited(_hapus(context, ref, menu)),
          icon: const Icon(Icons.delete_outline_rounded),
          label: const Text('Hapus menu'),
          style: OutlinedButton.styleFrom(
            foregroundColor: scheme.error,
            minimumSize: const Size.fromHeight(48),
          ),
        ),
      ],
    );
  }
}
