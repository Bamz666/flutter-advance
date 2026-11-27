import 'package:eatik_app/core/router/app_routes.dart';
import 'package:eatik_app/core/widgets/state_message.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({required this.location, super.key});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eatik')),
      body: StateMessage(
        icon: Icons.explore_off_rounded,
        title: 'Halaman tidak ditemukan',
        message: location,
        actionLabel: 'Ke Menu',
        onAction: () => context.goNamed(AppRoute.menu),
      ),
    );
  }
}
