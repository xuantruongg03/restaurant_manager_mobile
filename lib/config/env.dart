class Env {
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    // defaultValue: 'http://localhost:8082',
    defaultValue: 'http://192.168.1.178:8082',
  );
}
