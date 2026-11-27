import 'dart:async';

import 'package:eatik_app/core/router/app_routes.dart';
import 'package:eatik_app/core/widgets/async_value_view.dart';
import 'package:eatik_app/core/widgets/state_message.dart';
import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:eatik_app/features/menu/presentation/providers/favorit_menu_provider.dart';
import 'package:eatik_app/features/menu/presentation/providers/menu_list_provider.dart';
import 'package:eatik_app/features/menu/presentation/widgets/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritPage extends ConsumerWidget {
  const FavoritPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menus = ref.watch(menuListProvider);
    final favorit = ref.watch(favoritMenuProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorit')),
      body: AsyncValueView<List<Menu>>(
        value: menus,
        isEmpty: (daftar) => !daftar.any((menu) => favorit.contains(menu.id)),
        empty: const StateMessage(
          icon: Icons.favorite_border_rounded,
          title: 'Belum ada favorit',
          message: 'Tekan ikon hati pada menu untuk menambahkannya ke sini.',
        ),
        onRetry: () => ref.invalidate(menuListProvider),
        builder: (daftar) {
          final terpilih = daftar
              .where((menu) => favorit.contains(menu.id))
              .toList();

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: terpilih.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final menu = terpilih[index];
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
          );
        },
      ),
    );
  }
}
