import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:equatable/equatable.dart';

class MenuListState extends Equatable {
  const MenuListState._({
    required this.menus,
    required this.sedangMemuat,
    this.pesanError,
  });

  const MenuListState.awal() : this._(menus: const [], sedangMemuat: true);

  const MenuListState.memuat(List<Menu> menus)
    : this._(menus: menus, sedangMemuat: true);

  const MenuListState.berhasil(List<Menu> menus)
    : this._(menus: menus, sedangMemuat: false);

  const MenuListState.gagal(String pesan)
    : this._(menus: const [], sedangMemuat: false, pesanError: pesan);

  final List<Menu> menus;
  final bool sedangMemuat;
  final String? pesanError;

  @override
  List<Object?> get props => [menus, sedangMemuat, pesanError];
}
