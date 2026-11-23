import 'package:eatik_app/features/menu/domain/entities/menu.dart';

extension KategoriMenuLabel on KategoriMenu {
  String get label => switch (this) {
    KategoriMenu.makanan => 'Makanan',
    KategoriMenu.minuman => 'Minuman',
  };
}

extension StatusMenuLabel on StatusMenu {
  String get label => switch (this) {
    StatusMenu.tersedia => 'Tersedia',
    StatusMenu.habis => 'Habis',
  };
}
