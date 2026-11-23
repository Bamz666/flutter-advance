import 'package:eatik_app/features/menu/data/datasources/menu_fake_remote_data_source.dart';
import 'package:eatik_app/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:eatik_app/features/menu/domain/usecases/get_menus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Menyediakan use case GetMenus.
/// Perakitan dependency sementara berada di satu tempat ini.
/// Pada Modul 3 perakitan ini dipecah dan dirapikan.
final getMenusProvider = Provider<GetMenus>((ref) {
  return const GetMenus(MenuRepositoryImpl(MenuFakeRemoteDataSource()));
});
