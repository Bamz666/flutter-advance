import 'package:eatik_app/core/utils/rupiah_extension.dart';
import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:eatik_app/features/menu/presentation/providers/favorit_menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuCard extends ConsumerWidget {
  const MenuCard({required this.menu, this.onTap, super.key});

  final Menu menu;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final deskripsi = menu.deskripsi;
    final favorit = ref.watch(
      favoritMenuProvider.select((ids) => ids.contains(menu.id)),
    );

    return Opacity(
      opacity: menu.tersedia ? 1 : 0.55,
      child: Card.outlined(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 6, 14),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _ikon(menu.kategori),
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menu.nama,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (deskripsi != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          deskripsi,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall,
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            menu.harga.toRupiah(),
                            style: textTheme.titleSmall?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (!menu.tersedia) ...[
                            const SizedBox(width: 8),
                            Text(
                              'Habis',
                              style: textTheme.labelMedium?.copyWith(
                                color: scheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: favorit ? 'Hapus dari favorit' : 'Tambah ke favorit',
                  onPressed: () =>
                      ref.read(favoritMenuProvider.notifier).toggle(menu.id),
                  icon: Icon(
                    favorit
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                  ),
                  color: favorit ? scheme.error : scheme.outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _ikon(KategoriMenu kategori) {
    return switch (kategori) {
      KategoriMenu.makanan => Icons.restaurant_rounded,
      KategoriMenu.minuman => Icons.local_cafe_rounded,
    };
  }
}
