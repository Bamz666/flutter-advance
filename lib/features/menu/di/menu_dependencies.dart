import 'package:eatik_app/core/di/core_dependencies.dart';
import 'package:eatik_app/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:eatik_app/features/menu/data/datasources/menu_remote_data_source_impl.dart';
import 'package:eatik_app/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:eatik_app/features/menu/domain/repositories/menu_repository.dart';
import 'package:eatik_app/features/menu/domain/usecases/add_menu.dart';
import 'package:eatik_app/features/menu/domain/usecases/delete_menu.dart';
import 'package:eatik_app/features/menu/domain/usecases/get_menus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Composition root fitur Menu.

final menuRemoteDataSourceProvider = Provider<MenuRemoteDataSource>((ref) {
  return MenuRemoteDataSourceImpl(ref.watch(apiClientProvider));
});

final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  return MenuRepositoryImpl(ref.watch(menuRemoteDataSourceProvider));
});

final getMenusProvider = Provider<GetMenus>((ref) {
  return GetMenus(ref.watch(menuRepositoryProvider));
});

final addMenuProvider = Provider<AddMenu>((ref) {
  return AddMenu(ref.watch(menuRepositoryProvider));
});

final deleteMenuProvider = Provider<DeleteMenu>((ref) {
  return DeleteMenu(ref.watch(menuRepositoryProvider));
});
