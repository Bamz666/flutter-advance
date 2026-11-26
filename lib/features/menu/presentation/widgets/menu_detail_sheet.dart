import 'dart:async';

import 'package:eatik_app/core/utils/rupiah_extension.dart';
import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:eatik_app/features/menu/presentation/menu_labels.dart';
import 'package:eatik_app/features/menu/presentation/providers/menu_by_id_provider.dart';
import 'package:eatik_app/features/menu/presentation/providers/menu_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuDetailSheet extends ConsumerWidget {
  const MenuDetailSheet({required this.menuId, super.key});

  final int menuId;

  Future<void> _hapus(BuildContext context, WidgetRef ref, Menu menu) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
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

    navigator.pop();
    final failure = await ref.read(menuListProvider.notifier).hapus(menu.id);
    messenger.showSnackBar(
      SnackBar(content: Text(failure?.message ?? 'Menu dihapus')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menu = ref.watch(menuByIdProvider(menuId));
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (menu == null) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(24, 8, 24, 40),
        child: Text('Menu tidak ditemukan.'),
      );
    }

    final deskripsi = menu.deskripsi;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            menu.nama,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
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
      ),
    );
  }
}
