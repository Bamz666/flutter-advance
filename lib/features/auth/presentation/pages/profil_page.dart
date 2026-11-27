import 'dart:async';

import 'package:eatik_app/core/config/app_config.dart';
import 'package:eatik_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilPage extends ConsumerWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card.outlined(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.dns_outlined),
                  title: Text('Server'),
                  subtitle: Text(AppConfig.baseUrl),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.tune_rounded),
                  title: Text('Environment'),
                  subtitle: Text(AppConfig.env),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.tonalIcon(
            onPressed: () =>
                unawaited(ref.read(authProvider.notifier).keluar()),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Keluar'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              foregroundColor: scheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
