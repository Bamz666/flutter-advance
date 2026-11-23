import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State: kumpulan id menu yang ditandai favorit.
class FavoritMenuNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() => const {};

  void toggle(int id) {
    final baru = {...state};
    if (!baru.remove(id)) baru.add(id);
    state = baru;
  }
}

final favoritMenuProvider = NotifierProvider<FavoritMenuNotifier, Set<int>>(
  FavoritMenuNotifier.new,
);
