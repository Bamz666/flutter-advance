abstract final class AppConfig {
  static const String env = String.fromEnvironment('ENV', defaultValue: 'dev');

  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );
}
