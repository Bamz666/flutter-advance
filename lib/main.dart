import 'package:eatik_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      // Tanpa pengulangan otomatis: error langsung tampil di UI.
      retry: (retryCount, error) => null,
      child: const EatikApp(),
    ),
  );
}
