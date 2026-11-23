import 'package:eatik_app/features/menu/data/datasources/menu_fake_remote_data_source.dart';
import 'package:eatik_app/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:eatik_app/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:eatik_app/features/menu/domain/repositories/menu_repository.dart';
import 'package:eatik_app/features/menu/domain/usecases/get_menus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Composition root fitur Menu: satu-satunya tempat yang memilih
/// implementasi konkret. Perhatikan tipe pada setiap provider:
/// semuanya berupa abstraksi (interface), bukan class konkret.

final menuRemoteDataSourceProvider = Provider<MenuRemoteDataSource>((ref) {
  return const MenuFakeRemoteDataSource();
});

final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  return MenuRepositoryImpl(ref.watch(menuRemoteDataSourceProvider));
});

final getMenusProvider = Provider<GetMenus>((ref) {
  return GetMenus(ref.watch(menuRepositoryProvider));
});
