import 'dart:io';

import 'package:eatik_app/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:eatik_app/features/menu/data/models/menu_model.dart';

class MenuFakeRemoteDataSource implements MenuRemoteDataSource {
  const MenuFakeRemoteDataSource({this.simulasiOffline = false});

  /// Ubah menjadi true untuk melihat penanganan error pada UI.
  final bool simulasiOffline;

  static const List<Map<String, dynamic>> _json = [
    {
      'id': 1,
      'nama': 'Nasi Goreng Spesial',
      'harga': 25000.0,
      'deskripsi': 'Nasi goreng dengan telur dan ayam suwir',
      'kategori': 'MAKANAN',
      'foto': null,
      'status': 'TERSEDIA',
    },
    {
      'id': 2,
      'nama': 'Mie Ayam Bakso',
      'harga': 22000.0,
      'deskripsi': 'Mie ayam dengan bakso sapi',
      'kategori': 'MAKANAN',
      'foto': null,
      'status': 'TERSEDIA',
    },
    {
      'id': 3,
      'nama': 'Soto Betawi',
      'harga': 30000.0,
      'deskripsi': 'Soto santan dengan daging sapi',
      'kategori': 'MAKANAN',
      'foto': null,
      'status': 'HABIS',
    },
    {
      'id': 4,
      'nama': 'Nasi Biryani',
      'harga': 25000.0,
      'deskripsi': 'Nasi biryani spesial',
      'kategori': 'MAKANAN',
      'foto': null,
      'status': 'TERSEDIA',
    },
    {
      'id': 5,
      'nama': 'Es Teh Manis',
      'harga': 5000.0,
      'deskripsi': 'Teh dingin dengan gula',
      'kategori': 'MINUMAN',
      'foto': null,
      'status': 'TERSEDIA',
    },
    {
      'id': 6,
      'nama': 'Jus Alpukat',
      'harga': 15000.0,
      'deskripsi': 'Jus alpukat dengan susu cokelat',
      'kategori': 'MINUMAN',
      'foto': null,
      'status': 'TERSEDIA',
    },
    {
      'id': 7,
      'nama': 'Kopi Susu Gula Aren',
      'harga': 18000.0,
      'deskripsi': 'Kopi susu dengan gula aren',
      'kategori': 'MINUMAN',
      'foto': null,
      'status': 'TERSEDIA',
    },
    {
      'id': 8,
      'nama': 'Es Jeruk',
      'harga': 8000.0,
      'deskripsi': 'Perasan jeruk segar',
      'kategori': 'MINUMAN',
      'foto': null,
      'status': 'HABIS',
    },
  ];

  @override
  Future<List<MenuModel>> fetchMenus({String? nama, String? kategori}) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (simulasiOffline) {
      throw const SocketException('Simulasi: tidak ada koneksi');
    }

    final kataKunci = nama?.trim().toLowerCase() ?? '';

    return _json.map(MenuModel.fromJson).where((menu) {
      final cocokNama = menu.nama.toLowerCase().contains(kataKunci);
      final cocokKategori = kategori == null || menu.kategori == kategori;
      return cocokNama && cocokKategori;
    }).toList();
  }
}
