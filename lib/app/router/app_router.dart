import 'package:eatik_app/app/router/main_shell.dart';
import 'package:eatik_app/app/router/not_found_page.dart';
import 'package:eatik_app/core/router/app_routes.dart';
import 'package:eatik_app/features/auth/presentation/pages/profil_page.dart';
import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:eatik_app/features/menu/presentation/pages/favorit_page.dart';
import 'package:eatik_app/features/menu/presentation/pages/menu_detail_page.dart';
import 'package:eatik_app/features/menu/presentation/pages/menu_form_page.dart';
import 'package:eatik_app/features/menu/presentation/pages/menu_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppPath.menu,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // Tab 1: Menu
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppPath.menu,
                name: AppRoute.menu,
                builder: (context, state) {
                  final kategori = KategoriMenu.values
                      .asNameMap()[state.uri.queryParameters['kategori']];
                  return MenuPage(kategoriAwal: kategori);
                },
                routes: [
                  // Harus sebelum ':id' agar 'tambah' tidak dianggap id.
                  GoRoute(
                    path: 'tambah',
                    name: AppRoute.menuTambah,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const MenuFormPage(),
                  ),
                  GoRoute(
                    path: ':id',
                    name: AppRoute.menuDetail,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final id = int.tryParse(state.pathParameters['id'] ?? '');
                      if (id == null) {
                        return NotFoundPage(location: state.uri.toString());
                      }
                      final extra = state.extra;
                      return MenuDetailPage(
                        menuId: id,
                        menuAwal: extra is Menu ? extra : null,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // Tab 2: Favorit
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppPath.favorit,
                name: AppRoute.favorit,
                builder: (context, state) => const FavoritPage(),
              ),
            ],
          ),
          // Tab 3: Profil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppPath.profil,
                name: AppRoute.profil,
                builder: (context, state) => const ProfilPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
