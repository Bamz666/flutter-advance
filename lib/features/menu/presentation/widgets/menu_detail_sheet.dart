import 'package:eatik_app/core/utils/rupiah_extension.dart';
import 'package:eatik_app/features/menu/presentation/menu_labels.dart';
import 'package:eatik_app/features/menu/presentation/providers/menu_by_id_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuDetailSheet extends ConsumerWidget {
  const MenuDetailSheet({required this.menuId, super.key});

  final int menuId;

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
        ],
      ),
    );
  }
}
