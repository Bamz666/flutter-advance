import 'dart:async';

import 'package:eatik_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: 'Keluar',
      onPressed: () => unawaited(ref.read(authProvider.notifier).keluar()),
      icon: const Icon(Icons.logout_rounded),
    );
  }
}
