import 'package:eatik_app/app/app.dart';
import 'package:eatik_app/core/error/failure.dart';
import 'package:eatik_app/core/error/result.dart';
import 'package:eatik_app/features/menu/di/menu_dependencies.dart';
import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:eatik_app/features/menu/domain/repositories/menu_repository.dart';
import 'package:eatik_app/features/menu/presentation/providers/antrian_dapur_provider.dart';
import 'package:eatik_app/features/menu/presentation/widgets/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fake_menu_repository.dart';

const _contoh = [
  Menu(
    id: 1,
    nama: 'Menu Uji Satu',
    harga: 10000,
    kategori: KategoriMenu.makanan,
    status: StatusMenu.tersedia,
  ),
  Menu(
    id: 2,
    nama: 'Menu Uji Dua',
    harga: 5000,
    kategori: KategoriMenu.minuman,
    status: StatusMenu.habis,
  ),
];

Widget _aplikasiUji(MenuRepository repository) {
  return ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [
      menuRepositoryProvider.overrideWithValue(repository),
      antrianDapurProvider.overrideWith((ref) => Stream.value(0)),
    ],
    child: const EatikApp(),
  );
}

void main() {
  testWidgets('menampilkan daftar menu dari repository', (tester) async {
    await tester.pumpWidget(
      _aplikasiUji(const FakeMenuRepository(Success(_contoh))),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MenuCard), findsNWidgets(2));
    expect(find.text('Menu Uji Satu'), findsOneWidget);
    expect(find.text('Antrian 0'), findsOneWidget);
  });

  testWidgets('menampilkan pesan error saat repository gagal', (tester) async {
    await tester.pumpWidget(
      _aplikasiUji(const FakeMenuRepository(Failed(NetworkFailure()))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tidak ada koneksi internet.'), findsOneWidget);
    expect(find.text('Coba Lagi'), findsOneWidget);
  });

  testWidgets('menampilkan keadaan kosong', (tester) async {
    await tester.pumpWidget(
      _aplikasiUji(const FakeMenuRepository(Success(<Menu>[]))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Menu tidak ditemukan'), findsOneWidget);
  });
}
