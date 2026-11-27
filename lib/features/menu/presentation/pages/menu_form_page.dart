import 'dart:async';

import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:eatik_app/features/menu/presentation/menu_labels.dart';
import 'package:eatik_app/features/menu/presentation/providers/menu_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MenuFormPage extends ConsumerStatefulWidget {
  const MenuFormPage({super.key});

  @override
  ConsumerState<MenuFormPage> createState() => _MenuFormPageState();
}

class _MenuFormPageState extends ConsumerState<MenuFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _deskripsiController = TextEditingController();

  KategoriMenu _kategori = KategoriMenu.makanan;
  bool _tersedia = true;
  bool _sedangMengirim = false;
  String? _pesanError;

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  InputDecoration _dekorasi(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> _simpan() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    setState(() {
      _sedangMengirim = true;
      _pesanError = null;
    });

    final failure = await ref
        .read(menuListProvider.notifier)
        .tambah(
          nama: _namaController.text,
          harga: double.tryParse(_hargaController.text.trim()) ?? 0,
          deskripsi: _deskripsiController.text,
          kategori: _kategori,
          status: _tersedia ? StatusMenu.tersedia : StatusMenu.habis,
        );

    if (!mounted) return;

    if (failure == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Menu berhasil ditambahkan')),
      );
      router.pop();
      return;
    }

    setState(() {
      _sedangMengirim = false;
      _pesanError = failure.message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pesan = _pesanError;

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Menu')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _namaController,
                  textInputAction: TextInputAction.next,
                  decoration: _dekorasi('Nama menu'),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Wajib diisi'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _hargaController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: _dekorasi('Harga (Rp)'),
                  validator: (value) {
                    final angka = double.tryParse((value ?? '').trim());
                    return (angka == null || angka <= 0)
                        ? 'Masukkan harga yang valid'
                        : null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _deskripsiController,
                  maxLines: 3,
                  decoration: _dekorasi('Deskripsi (opsional)'),
                ),
                const SizedBox(height: 20),
                Text('Kategori', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                SegmentedButton<KategoriMenu>(
                  segments: [
                    for (final kategori in KategoriMenu.values)
                      ButtonSegment<KategoriMenu>(
                        value: kategori,
                        label: Text(kategori.label),
                      ),
                  ],
                  selected: {_kategori},
                  onSelectionChanged: (pilihan) =>
                      setState(() => _kategori = pilihan.first),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Tersedia'),
                  value: _tersedia,
                  onChanged: (value) => setState(() => _tersedia = value),
                ),
                if (pesan != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    pesan,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: scheme.error),
                  ),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: _sedangMengirim
                      ? null
                      : () => unawaited(_simpan()),
                  child: _sedangMengirim
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
