import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../error/exceptions.dart';

abstract class ApiClient {
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  });
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  });
  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  });
}

class ApiClientImpl implements ApiClient {
  final http.Client client;
  final String baseUrl;
  final Future<String?> Function()? tokenGetter;

  ApiClientImpl({
    http.Client? client,
    this.baseUrl = ApiConstants.baseUrl,
    this.tokenGetter,
  }) : client = client ?? http.Client();

  Uri _buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    final cleanPath = path.startsWith('/') ? path : '/$path';
    final fullUrl = path.startsWith('http') ? path : '$baseUrl$cleanPath';
    final uri = Uri.parse(fullUrl);
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(
        queryParameters: queryParameters.map(
          (k, v) => MapEntry(k, v.toString()),
        ),
      );
    }
    return uri;
  }

  Future<Map<String, String>> _buildHeaders(Map<String, String>? customHeaders) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?customHeaders,
    };

    if (tokenGetter != null && !headers.containsKey('Authorization')) {
      final token = await tokenGetter!();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  @override
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _buildUri(path, queryParameters);
    try {
      final requestHeaders = await _buildHeaders(headers);
      final response = await client.get(uri, headers: requestHeaders);
      return _processResponse(response);
    } on SocketException {
      throw const NetworkException(
        'Gagal terhubung ke server backend. Pastikan server aktif.',
      );
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final uri = _buildUri(path);
    final requestHeaders = await _buildHeaders(headers);
    final requestBody = body != null ? jsonEncode(body) : null;

    try {
      final response = await client.post(
        uri,
        headers: requestHeaders,
        body: requestBody,
      );
      return _processResponse(response);
    } on SocketException {
      throw const NetworkException(
        'Gagal terhubung ke server backend. Pastikan server aktif.',
      );
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final uri = _buildUri(path);
    final requestHeaders = await _buildHeaders(headers);
    final requestBody = body != null ? jsonEncode(body) : null;

    try {
      final response = await client.delete(
        uri,
        headers: requestHeaders,
        body: requestBody,
      );
      return _processResponse(response);
    } on SocketException {
      throw const NetworkException(
        'Gagal terhubung ke server backend. Pastikan server aktif.',
      );
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(e.toString());
    }
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = null;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'data': decoded};
    }

    String errorMessage =
        'Terjadi kesalahan pada server (${response.statusCode})';

    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('errors') && decoded['errors'] is Map) {
        final errorsMap = decoded['errors'] as Map<String, dynamic>;
        if (errorsMap.isNotEmpty) {
          final firstErrorKey = errorsMap.keys.first;
          final firstErrorList = errorsMap[firstErrorKey];
          if (firstErrorList is List && firstErrorList.isNotEmpty) {
            errorMessage = firstErrorList.first.toString();
          } else {
            errorMessage = firstErrorList.toString();
          }
        }
      } else if (decoded.containsKey('message') && decoded['message'] != null) {
        errorMessage = decoded['message'].toString();
      }
    }

    throw ServerException(errorMessage);
  }
}
