import 'package:eatik_app/app/router/main_shell.dart';
import 'package:eatik_app/app/router/not_found_page.dart';
import 'package:eatik_app/app/router/splash_page.dart';
import 'package:eatik_app/core/router/app_routes.dart';
import 'package:eatik_app/features/auth/presentation/pages/auth_page.dart';
import 'package:eatik_app/features/auth/presentation/pages/profil_page.dart';
import 'package:eatik_app/features/auth/presentation/providers/auth_provider.dart';
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
  // Memberi sinyal pada GoRouter setiap kali status login berubah,
  // sehingga redirect dievaluasi ulang.
  final refresh = ValueNotifier<int>(0);
  ref.onDispose(refresh.dispose);
  ref.listen(authProvider, (previous, next) => refresh.value++);

  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppPath.menu,
    refreshListenable: refresh,
    redirect: (context, state) => _redirect(ref, state),
    errorBuilder: (context, state) {
      return NotFoundPage(location: state.uri.toString());
    },
    routes: [
      GoRoute(path: '/', redirect: (context, state) => AppPath.menu),
      GoRoute(
        path: AppPath.splash,
        name: AppRoute.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppPath.masuk,
        name: AppRoute.masuk,
        builder: (context, state) => const AuthPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppPath.favorit,
                name: AppRoute.favorit,
                builder: (context, state) => const FavoritPage(),
              ),
            ],
          ),
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

/// Authentication guard: menentukan apakah pengguna perlu dibelokkan.
/// Mengembalikan null bila tidak perlu.
String? _redirect(Ref ref, GoRouterState state) {
  final auth = ref.read(authProvider);
  final lokasi = state.matchedLocation;
  final diSplash = lokasi == AppPath.splash;
  final diMasuk = lokasi == AppPath.masuk;

  // Tujuan awal yang dititipkan. Hanya path internal yang diterima.
  final titipan = state.uri.queryParameters['dari'];
  final dari = (titipan != null && titipan.startsWith('/')) ? titipan : null;

  // 1. Sesi sedang diperiksa.
  if (auth.isLoading) {
    if (diSplash) return null;
    return _lokasi(AppPath.splash, state.uri.toString());
  }

  final sudahMasuk = auth.value ?? false;

  // 2. Belum masuk: paksa ke halaman masuk, titip tujuan awal.
  if (!sudahMasuk) {
    if (diMasuk) return null;
    final tujuan = diSplash ? dari : state.uri.toString();
    return _lokasi(AppPath.masuk, tujuan);
  }

  // 3. Sudah masuk: tidak perlu lagi berada di splash atau masuk.
  if (diMasuk || diSplash) return dari ?? AppPath.menu;

  return null;
}

String _lokasi(String path, String? dari) {
  return Uri(
    path: path,
    queryParameters: dari == null ? null : {'dari': dari},
  ).toString();
}
