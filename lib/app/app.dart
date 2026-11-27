import 'package:eatik_app/app/router/app_router.dart';
import 'package:eatik_app/app/theme/app_theme.dart';
import 'package:eatik_app/features/auth/presentation/pages/auth_page.dart';
import 'package:eatik_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EatikApp extends ConsumerWidget {
  const EatikApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    // SEMENTARA: pengecekan login di sini. Diganti guard go_router (Pertemuan 9).
    if (!(auth.value ?? false)) {
      return MaterialApp(
        title: 'Eatik',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: auth.isLoading ? const _MemeriksaSesi() : const AuthPage(),
      );
    }

    return MaterialApp.router(
      title: 'Eatik',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: ref.watch(routerProvider),
    );
  }
}

class _MemeriksaSesi extends StatelessWidget {
  const _MemeriksaSesi();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
