import 'package:eatik_app/core/error/failure.dart';
import 'package:eatik_app/core/widgets/state_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Menampilkan empat kondisi UI dari sebuah AsyncValue:
/// loading, error, empty, dan data.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    required this.value,
    required this.builder,
    required this.isEmpty,
    required this.empty,
    required this.onRetry,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final bool Function(T data) isEmpty;
  final Widget empty;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return value.when(
      // Saat memuat ulang, data lama tetap tampil.
      skipLoadingOnReload: true,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => StateMessage(
        icon: Icons.cloud_off_rounded,
        title: 'Gagal memuat data',
        message: error is Failure ? error.message : 'Terjadi kesalahan.',
        actionLabel: 'Coba Lagi',
        onAction: onRetry,
      ),
      data: (data) => isEmpty(data) ? empty : builder(data),
    );
  }
}
