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
  @override
  MenuFilter build() => const MenuFilter();

  void ubahKataKunci(String value) {
    state = MenuFilter(kataKunci: value, kategori: state.kategori);
  }

  void pilihKategori(KategoriMenu? kategori) {
    state = MenuFilter(kataKunci: state.kataKunci, kategori: kategori);
  }
}

final menuFilterProvider = NotifierProvider<MenuFilterNotifier, MenuFilter>(
  MenuFilterNotifier.new,
);
