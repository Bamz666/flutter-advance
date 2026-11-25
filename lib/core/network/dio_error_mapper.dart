import 'package:dio/dio.dart';
import 'package:eatik_app/core/error/failure.dart';

/// Mengubah DioException menjadi Failure agar layer lain tidak mengenal Dio.
Failure mapDioException(DioException error) {
  return switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.connectionError => const NetworkFailure(),
    DioExceptionType.badResponse => _dariResponse(error.response),
    DioExceptionType.cancel => const UnknownFailure('Permintaan dibatalkan.'),
    _ => const UnknownFailure(),
  };
}

Failure _dariResponse(Response<dynamic>? response) {
  final status = response?.statusCode;

  if (status == 401 || status == 403) return const UnauthorizedFailure();
  if (status != null && status >= 500) return const ServerFailure();

  // Status 400 membawa pesan bisnis dari server (misalnya password salah).
  return ServerFailure(
    _ambilPesan(response?.data) ?? 'Permintaan tidak dapat diproses.',
  );
}

String? _ambilPesan(Object? data) {
  if (data is Map<String, dynamic>) {
    final pesan = data['message'];
    if (pesan is String && pesan.isNotEmpty) return pesan;
  }
  return null;
}
