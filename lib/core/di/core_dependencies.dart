import 'package:eatik_app/core/config/app_config.dart';
import 'package:eatik_app/core/network/api_client.dart';
import 'package:eatik_app/core/network/session_expired_provider.dart';
import 'package:eatik_app/core/storage/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return SecureTokenStorage(FlutterSecureStorage());
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: AppConfig.baseUrl,
    tokenStorage: ref.watch(tokenStorageProvider),
    onSessionExpired: () => ref.read(sessionExpiredProvider.notifier).terjadi(),
  );
});
