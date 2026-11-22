import 'dart:async';

import 'package:eatik_app/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:eatik_app/features/menu/domain/repositories/menu_repository.dart';
import 'package:eatik_app/features/menu/presentation/widgets/menu_card.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final MenuRepository _repository = const MenuRepositoryImpl();

  List<Menu> _menus = const [];
  bool _sedangMemuat = true;
  String _kataKunci = '';
  KategoriMenu? _kategori;

  @override
  void initState() {
    super.initState();
    unawaited(_muat());
  }

  Future<void> _muat() async {
    setState(() => _sedangMemuat = true);

    final hasil = await _repository.getMenus(
      nama: _kataKunci,
      kategori: _kategori,
    );

    if (!mounted) return;
    setState(() {
      _menus = hasil;
      _sedangMemuat = false;
    });
  }

  String _labelKategori(KategoriMenu? kategori) {
    return switch (kategori) {
      null => 'Semua',
      KategoriMenu.makanan => 'Makanan',
      KategoriMenu.minuman => 'Minuman',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Eatik')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (value) {
                _kataKunci = value;
                unawaited(_muat());
              },
              decoration: InputDecoration(
                hintText: 'Cari menu...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                for (final kategori in [null, ...KategoriMenu.values])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_labelKategori(kategori)),
                      selected: _kategori == kategori,
                      onSelected: (_) {
                        setState(() => _kategori = kategori);
                        unawaited(_muat());
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(child: _buildDaftar()),
        ],
      ),
    );
  }

  Widget _buildDaftar() {
    if (_sedangMemuat) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_menus.isEmpty) {
      return const Center(child: Text('Menu tidak ditemukan'));
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: _menus.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => MenuCard(menu: _menus[index]),
    );
  }
}
