import 'package:flutter/material.dart';

class StateMessage extends StatelessWidget {
  const StateMessage({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pesan = message;
    final label = actionLabel;
    final aksi = onAction;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: scheme.outline),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (pesan != null) ...[
              const SizedBox(height: 6),
              Text(
                pesan,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            if (label != null && aksi != null) ...[
              const SizedBox(height: 20),
              FilledButton.tonal(onPressed: aksi, child: Text(label)),
            ],
          ],
        ),
      ),
    );
  }
}
