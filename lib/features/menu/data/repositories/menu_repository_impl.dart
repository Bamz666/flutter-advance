import 'dart:io';

import 'package:eatik_app/core/error/failure.dart';
import 'package:eatik_app/core/error/result.dart';
import 'package:eatik_app/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:eatik_app/features/menu/domain/entities/menu.dart';
import 'package:eatik_app/features/menu/domain/repositories/menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  const MenuRepositoryImpl(this._remoteDataSource);

  final MenuRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<Menu>>> getMenus({
    String? nama,
    KategoriMenu? kategori,
  }) async {
    try {
      final models = await _remoteDataSource.fetchMenus(
        nama: nama,
        // Nama enum 'makanan' menjadi 'MAKANAN' sesuai nilai pada API.
        kategori: kategori?.name.toUpperCase(),
      );
      return Success(models.map((model) => model.toEntity()).toList());
    } on SocketException {
      return const Failed(NetworkFailure());
    } on FormatException {
      return const Failed(ParsingFailure());
    } on Exception {
      return const Failed(UnknownFailure());
    }
  }
}
