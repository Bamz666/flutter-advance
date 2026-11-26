import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eatik_app/core/error/failure.dart';
import 'package:eatik_app/core/error/result.dart';
import 'package:eatik_app/core/network/dio_error_mapper.dart';

/// Menjalankan aksi jaringan dan mengubah semua kegagalan menjadi Failed.
Future<Result<T>> safeApiCall<T>(Future<T> Function() aksi) async {
  try {
    return Success(await aksi());
  } on DioException catch (error) {
    return Failed(mapDioException(error));
  } on SocketException {
    return Failed(const NetworkFailure());
  } on FormatException {
    return Failed(const ParsingFailure());
  } on TypeError {
    return Failed(const ParsingFailure());
  } on Exception {
    return Failed(const UnknownFailure());
  }
}
