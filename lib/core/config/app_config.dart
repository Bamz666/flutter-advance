abstract final class AppConfig {
  static const String env = String.fromEnvironment('ENV', defaultValue: 'dev');

  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://192.168.8.86:8080',
  );
}
