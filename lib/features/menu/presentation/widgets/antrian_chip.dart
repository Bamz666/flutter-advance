import 'package:eatik_app/features/menu/presentation/providers/antrian_dapur_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AntrianChip extends ConsumerWidget {
  const AntrianChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teks = ref
        .watch(antrianDapurProvider)
        .when(
          data: (jumlah) => 'Antrian $jumlah',
          loading: () => 'Antrian ...',
          error: (error, stackTrace) => 'Antrian -',
        );

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Chip(
        avatar: const Icon(Icons.receipt_long_rounded, size: 18),
        label: Text(teks),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
