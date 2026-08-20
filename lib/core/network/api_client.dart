abstract class ApiClient {
  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? queryParameters});
  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body});
}

class ApiClientImpl implements ApiClient {
  @override
  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? queryParameters}) async {
    // Stub client implementation
    return {};
  }

  @override
  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body}) async {
    // Stub client implementation
    return {};
  }
}
