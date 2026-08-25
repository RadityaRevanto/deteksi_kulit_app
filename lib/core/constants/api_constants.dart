class ApiConstants {
  static const String baseUrl = 'http://localhost:8000/api/v1';

  static const String registerEndpoint = '/register';
  static const String loginEndpoint = '/login';
  static const String historyEndpoint = '/history';
  static const String profileEndpoint = '/profile';

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
