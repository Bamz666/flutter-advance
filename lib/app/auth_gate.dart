import 'package:eatik_app/features/auth/presentation/pages/auth_page.dart';
import 'package:eatik_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:eatik_app/features/menu/presentation/pages/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return auth.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => const AuthPage(),
      data: (sudahMasuk) => sudahMasuk ? const MenuPage() : const AuthPage(),
    );
  }
}
