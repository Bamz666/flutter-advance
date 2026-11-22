import 'package:eatik_app/core/utils/rupiah_extension.dart';
import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({required this.menu, super.key});

  final Menu menu;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final deskripsi = menu.deskripsi;

    return Opacity(
      opacity: menu.tersedia ? 1 : 0.55,
      child: Card.outlined(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(14),
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
                    Text(
                      menu.harga.toRupiah(),
                      style: textTheme.titleSmall?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
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
