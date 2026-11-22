import 'package:equatable/equatable.dart';

enum KategoriMenu { makanan, minuman }

enum StatusMenu { tersedia, habis }

class Menu extends Equatable {
  const Menu({
    required this.id,
    required this.nama,
    required this.harga,
    required this.kategori,
    required this.status,
    this.deskripsi,
    this.foto,
  });

  final int id;
  final String nama;
  final double harga;
  final String? deskripsi;
  final KategoriMenu kategori;
  final String? foto;
  final StatusMenu status;

  bool get tersedia => status == StatusMenu.tersedia;

  @override
  List<Object?> get props => [
    id,
    nama,
    harga,
    deskripsi,
    kategori,
    foto,
    status,
  ];
}
