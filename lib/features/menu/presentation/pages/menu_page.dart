import 'dart:async';

import 'package:eatik_app/core/error/result.dart';
import 'package:eatik_app/features/menu/data/datasources/menu_fake_remote_data_source.dart';
import 'package:eatik_app/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:eatik_app/features/menu/domain/usecases/get_menus.dart';
import 'package:eatik_app/features/menu/presentation/widgets/menu_card.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // Sementara: dependency dibuat langsung di sini (hard dependency).
  // Akan dirapikan dengan Riverpod (Modul 2) dan DI (Modul 3).
  final GetMenus _getMenus = const GetMenus(
    MenuRepositoryImpl(MenuFakeRemoteDataSource()),
  );

  List<Menu> _menus = const [];
  bool _sedangMemuat = true;
  String? _pesanError;
  String _kataKunci = '';
  KategoriMenu? _kategori;

  @override
  void initState() {
    super.initState();
    unawaited(_muat());
  }

  Future<void> _muat() async {
    setState(() {
      _sedangMemuat = true;
      _pesanError = null;
    });

    final hasil = await _getMenus(nama: _kataKunci, kategori: _kategori);

    if (!mounted) return;
    setState(() {
      _sedangMemuat = false;
      switch (hasil) {
        case Success(:final data):
          _menus = data;
        case Failed(:final failure):
          _pesanError = failure.message;
      }
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

    final pesan = _pesanError;
    if (pesan != null) {
      return _PesanError(pesan: pesan, onCobaLagi: () => unawaited(_muat()));
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

class _PesanError extends StatelessWidget {
  const _PesanError({required this.pesan, required this.onCobaLagi});

  final String pesan;
  final VoidCallback onCobaLagi;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 48, color: scheme.outline),
            const SizedBox(height: 16),
            Text(pesan, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: onCobaLagi,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
