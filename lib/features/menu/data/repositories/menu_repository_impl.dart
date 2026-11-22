import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:eatik_app/features/menu/domain/repositories/menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  const MenuRepositoryImpl();

  static const List<Menu> _data = [
    Menu(
      id: 1,
      nama: 'Nasi Goreng Spesial',
      harga: 25000,
      deskripsi: 'Nasi goreng dengan telur dan ayam suwir',
      kategori: KategoriMenu.makanan,
      status: StatusMenu.tersedia,
    ),
    Menu(
      id: 2,
      nama: 'Mie Ayam Bakso',
      harga: 22000,
      deskripsi: 'Mie ayam dengan bakso sapi',
      kategori: KategoriMenu.makanan,
      status: StatusMenu.tersedia,
    ),
    Menu(
      id: 3,
      nama: 'Soto Betawi',
      harga: 30000,
      deskripsi: 'Soto santan dengan daging sapi',
      kategori: KategoriMenu.makanan,
      status: StatusMenu.habis,
    ),
    Menu(
      id: 4,
      nama: 'Nasi Biryani',
      harga: 25000,
      deskripsi: 'Nasi biryani spesial',
      kategori: KategoriMenu.makanan,
      status: StatusMenu.tersedia,
    ),
    Menu(
      id: 5,
      nama: 'Es Teh Manis',
      harga: 5000,
      deskripsi: 'Teh dingin dengan gula',
      kategori: KategoriMenu.minuman,
      status: StatusMenu.tersedia,
    ),
    Menu(
      id: 6,
      nama: 'Jus Alpukat',
      harga: 15000,
      deskripsi: 'Jus alpukat dengan susu cokelat',
      kategori: KategoriMenu.minuman,
      status: StatusMenu.tersedia,
    ),
    Menu(
      id: 7,
      nama: 'Kopi Susu Gula Aren',
      harga: 18000,
      deskripsi: 'Kopi susu dengan gula aren',
      kategori: KategoriMenu.minuman,
      status: StatusMenu.tersedia,
    ),
    Menu(
      id: 8,
      nama: 'Es Jeruk',
      harga: 8000,
      deskripsi: 'Perasan jeruk segar',
      kategori: KategoriMenu.minuman,
      status: StatusMenu.habis,
    ),
  ];

  @override
  Future<List<Menu>> getMenus({String? nama, KategoriMenu? kategori}) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final kataKunci = nama?.trim().toLowerCase() ?? '';

    return _data.where((menu) {
      final cocokNama = menu.nama.toLowerCase().contains(kataKunci);
      final cocokKategori = kategori == null || menu.kategori == kategori;
      return cocokNama && cocokKategori;
    }).toList();
  }
}
