import 'package:dio/dio.dart';
import 'package:eatik_app/core/network/auth_interceptor.dart';
import 'package:eatik_app/core/storage/token_storage.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  ApiClient({
    required String baseUrl,
    required TokenStorage tokenStorage,
    required void Function() onSessionExpired,
  }) : dio = Dio(_opsi(baseUrl)) {
    dio.interceptors.add(
      AuthInterceptor(
        tokenStorage: tokenStorage,
        refreshDio: Dio(_opsi(baseUrl)),
        onSessionExpired: onSessionExpired,
      ),
    );

    // Logging ringkas hanya saat debug. Header, body, dan token TIDAK dicetak.
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: false,
          requestBody: false,
          responseHeader: false,
          responseBody: false,
        ),
      );
    }
  }

  final Dio dio;

  static BaseOptions _opsi(String baseUrl) {
    return BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) {
    return dio.get<T>(
      path,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    CancelToken? cancelToken,
  }) {
    return dio.post<T>(path, data: data, cancelToken: cancelToken);
  }

  Future<Response<T>> delete<T>(String path, {CancelToken? cancelToken}) {
    return dio.delete<T>(path, cancelToken: cancelToken);
  }
}
