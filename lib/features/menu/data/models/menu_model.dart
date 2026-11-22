import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:json_annotation/json_annotation.dart';

part 'menu_model.g.dart';

@JsonSerializable()
class MenuModel {
  const MenuModel({
    required this.id,
    required this.nama,
    required this.harga,
    required this.kategori,
    this.deskripsi,
    this.foto,
    this.status,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) =>
      _$MenuModelFromJson(json);

  final int id;
  final String nama;
  final double harga;
  final String? deskripsi;
  final String kategori;
  final String? foto;
  final String? status;

  Map<String, dynamic> toJson() => _$MenuModelToJson(this);

  Menu toEntity() {
    return Menu(
      id: id,
      nama: nama,
      harga: harga,
      deskripsi: deskripsi,
      foto: foto,
      kategori: _parseKategori(kategori),
      status: _parseStatus(status),
    );
  }
}

KategoriMenu _parseKategori(String value) {
  return switch (value.toUpperCase()) {
    'MAKANAN' => KategoriMenu.makanan,
    'MINUMAN' => KategoriMenu.minuman,
    _ => throw FormatException('Kategori tidak dikenal: $value'),
  };
}

StatusMenu _parseStatus(String? value) {
  return switch (value?.toUpperCase()) {
    'HABIS' => StatusMenu.habis,
    'TERSEDIA' || null => StatusMenu.tersedia,
    _ => throw FormatException('Status tidak dikenal: $value'),
  };
}
