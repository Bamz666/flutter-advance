import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:eatik_app/features/menu/presentation/providers/menu_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final menuByIdProvider = Provider.autoDispose.family<Menu?, int>((ref, id) {
  final daftar = ref.watch(menuListProvider).value ?? const <Menu>[];

  for (final menu in daftar) {
    if (menu.id == id) return menu;
  }
  return null;
});
