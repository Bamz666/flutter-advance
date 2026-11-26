import 'package:dio/dio.dart';
import 'package:eatik_app/core/storage/token_storage.dart';

/// Menambahkan header Authorization dan memperbarui token yang kedaluwarsa.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.tokenStorage,
    required this.refreshDio,
    required this.onSessionExpired,
  });

  final TokenStorage tokenStorage;

  /// Dio terpisah (tanpa interceptor) agar proses refresh tidak berputar.
  final Dio refreshDio;
  final void Function() onSessionExpired;

  static const _jalurPublik = [
    '/auth/login',
    '/auth/register',
    '/auth/refresh',
  ];
  static const _sudahDicoba = 'sudahDicoba';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_jalurPublik.contains(options.path)) {
      final token = await tokenStorage.readAccessToken();
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final status = err.response?.statusCode;

    final perluRefresh =
        (status == 401 || status == 403) &&
        !_jalurPublik.contains(request.path) &&
        request.extra[_sudahDicoba] != true;

    if (!perluRefresh) {
      handler.next(err);
      return;
    }

    final tokenBaru = await _perbaruiToken();
    if (tokenBaru == null) {
      handler.next(err);
      return;
    }

    try {
      request.extra[_sudahDicoba] = true;
      request.headers['Authorization'] = 'Bearer $tokenBaru';

      // FormData hanya bisa dikirim sekali, jadi salin sebelum diulang.
      final body = request.data;
      if (body is FormData) request.data = body.clone();

      final response = await refreshDio.fetch<dynamic>(request);
      handler.resolve(response);
    } on DioException catch (error) {
      handler.next(error);
    }
  }

  Future<String?> _perbaruiToken() async {
    final refreshToken = await tokenStorage.readRefreshToken();

    if (refreshToken != null) {
      try {
        final response = await refreshDio.post<Map<String, dynamic>>(
          '/auth/refresh',
          data: {'refreshToken': refreshToken},
        );
        final akses = response.data?['accessToken'];
        final refresh = response.data?['refreshToken'];

        if (akses is String && refresh is String) {
          await tokenStorage.saveTokens(
            accessToken: akses,
            refreshToken: refresh,
          );
          return akses;
        }
      } on DioException catch (error) {
        // Gangguan jaringan: jangan hapus sesi, cukup gagalkan request ini.
        if (error.type != DioExceptionType.badResponse) return null;
      }
    }

    // Refresh token tidak ada atau ditolak server: sesi berakhir.
    await tokenStorage.clear();
    onSessionExpired();
    return null;
  }
}
