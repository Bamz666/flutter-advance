import 'package:flutter/material.dart';

class MenuPageMessy extends StatefulWidget {
  const MenuPageMessy({super.key});

  @override
  State<MenuPageMessy> createState() => _MenuPageMessyState();
}

class _MenuPageMessyState extends State<MenuPageMessy> {
  final List<Map<String, dynamic>> _data = [
    {
      'nama': 'Nasi Goreng Spesial',
      'harga': 25000,
      'deskripsi': 'Nasi goreng dengan telur dan ayam suwir',
      'kategori': 'MAKANAN',
      'status': 'TERSEDIA',
    },
    {
      'nama': 'Mie Ayam Bakso',
      'harga': 22000,
      'deskripsi': 'Mie ayam dengan bakso sapi',
      'kategori': 'MAKANAN',
      'status': 'TERSEDIA',
    },
    {
      'nama': 'Soto Betawi',
      'harga': 30000,
      'deskripsi': 'Soto santan dengan daging sapi',
      'kategori': 'MAKANAN',
      'status': 'HABIS',
    },
    {
      'nama': 'Nasi Biryani',
      'harga': 25000,
      'deskripsi': 'Nasi biryani spesial',
      'kategori': 'MAKANAN',
      'status': 'TERSEDIA',
    },
    {
      'nama': 'Es Teh Manis',
      'harga': 5000,
      'deskripsi': 'Teh dingin dengan gula',
      'kategori': 'MINUMAN',
      'status': 'TERSEDIA',
    },
    {
      'nama': 'Jus Alpukat',
      'harga': 15000,
      'deskripsi': 'Jus alpukat dengan susu cokelat',
      'kategori': 'MINUMAN',
      'status': 'TERSEDIA',
    },
    {
      'nama': 'Kopi Susu Gula Aren',
      'harga': 18000,
      'deskripsi': 'Kopi susu dengan gula aren',
      'kategori': 'MINUMAN',
      'status': 'TERSEDIA',
    },
    {
      'nama': 'Es Jeruk',
      'harga': 8000,
      'deskripsi': 'Perasan jeruk segar',
      'kategori': 'MINUMAN',
      'status': 'HABIS',
    },
  ];

  String _kataKunci = '';
  String _kategori = 'SEMUA';

  @override
  Widget build(BuildContext context) {
    final tampil = _data.where((m) {
      final nama = (m['nama'] as String).toLowerCase();
      final cocokNama = nama.contains(_kataKunci.toLowerCase());
      final cocokKategori = _kategori == 'SEMUA' || m['kategori'] == _kategori;
      return cocokNama && cocokKategori;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Menu Eatik')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _kataKunci = v),
              decoration: const InputDecoration(
                hintText: 'Cari menu...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Row(
            children: [
              for (final k in ['SEMUA', 'MAKANAN', 'MINUMAN'])
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(k),
                    selected: _kategori == k,
                    onSelected: (_) => setState(() => _kategori = k),
                  ),
                ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tampil.length,
              itemBuilder: (context, i) {
                final m = tampil[i];
                final harga = (m['harga'] as int).toString();
                var hargaTeks = '';
                for (var j = 0; j < harga.length; j++) {
                  hargaTeks += harga[j];
                  final sisa = harga.length - j - 1;
                  if (sisa > 0 && sisa % 3 == 0) hargaTeks += '.';
                }
                return ListTile(
                  enabled: m['status'] != 'HABIS',
                  title: Text(m['nama'] as String),
                  subtitle: Text(m['deskripsi'] as String),
                  trailing: Text('Rp $hargaTeks'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
