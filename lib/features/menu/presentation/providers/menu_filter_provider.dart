import 'dart:async';

import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuFilter extends Equatable {
  const MenuFilter({this.kataKunci = '', this.kategori});

  final String kataKunci;
  final KategoriMenu? kategori;

  @override
  List<Object?> get props => [kataKunci, kategori];
}

class MenuFilterNotifier extends Notifier<MenuFilter> {
  Timer? _debounce;

  @override
  MenuFilter build() {
    ref.onDispose(() => _debounce?.cancel());
    return const MenuFilter();
  }

  void ubahKataKunci(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!ref.mounted) return;
      state = MenuFilter(kataKunci: value, kategori: state.kategori);
    });
  }

  void pilihKategori(KategoriMenu? kategori) {
    state = MenuFilter(kataKunci: state.kataKunci, kategori: kategori);
  }
}

final menuFilterProvider =
    NotifierProvider.autoDispose<MenuFilterNotifier, MenuFilter>(
      MenuFilterNotifier.new,
    );
