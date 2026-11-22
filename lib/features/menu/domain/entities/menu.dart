enum KategoriMenu { makanan, minuman }

enum StatusMenu { tersedia, habis }

class Menu {
  const Menu({
    required this.id,
    required this.nama,
    required this.harga,
    required this.kategori,
    required this.status,
    this.deskripsi,
  });

  final int id;
  final String nama;
  final double harga;
  final String? deskripsi;
  final KategoriMenu kategori;
  final StatusMenu status;

  bool get tersedia => status == StatusMenu.tersedia;
}
