import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/scan_result_model.dart';

abstract class ScanRemoteDataSource {
  Future<ScanResultModel> uploadScan(File imageFile);
  Future<ScanResultModel> livecamScan(File imageFile);
  Future<List<ScanResultModel>> getScanHistory();
  Future<void> sendFeedback(String uuid, bool isAccurate);
}

class ScanRemoteDataSourceImpl implements ScanRemoteDataSource {
  final ApiClient apiClient;
  final Future<String?> Function()? tokenGetter;
  final String baseUrl;

  ScanRemoteDataSourceImpl({
    ApiClient? apiClient,
    this.tokenGetter,
    this.baseUrl = ApiConstants.baseUrl,
  }) : apiClient = apiClient ?? ApiClientImpl();

  Future<ScanResultModel> _uploadImageToEndpoint(String endpoint, File imageFile) async {
    final cleanPath = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    final uri = Uri.parse('$baseUrl$cleanPath');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Accept'] = 'application/json';
    if (tokenGetter != null) {
      final token = await tokenGetter!();
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
    }

    final multipartFile = await http.MultipartFile.fromPath('image', imageFile.path);
    request.files.add(multipartFile);

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      dynamic decoded;
      try {
        decoded = jsonDecode(response.body);
      } catch (_) {}

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (decoded is Map<String, dynamic>) {
          return ScanResultModel.fromJson(decoded);
        }
        throw const ServerException('Format respon server tidak sesuai');
      }

      String errorMessage = 'Terjadi kesalahan pada server (${response.statusCode})';
      if (decoded is Map<String, dynamic> && decoded.containsKey('message')) {
        errorMessage = decoded['message'].toString();
      }

      throw ServerException(errorMessage);
    } on SocketException {
      throw const NetworkException('Gagal terhubung ke server backend. Pastikan server aktif.');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ScanResultModel> uploadScan(File imageFile) async {
    return await _uploadImageToEndpoint('/scans', imageFile);
  }

  @override
  Future<ScanResultModel> livecamScan(File imageFile) async {
    return await _uploadImageToEndpoint('/scans/livecam', imageFile);
  }

  @override
  Future<List<ScanResultModel>> getScanHistory() async {
    final response = await apiClient.get('/scans');
    final list = <ScanResultModel>[];
    if (response.containsKey('data') && response['data'] is List) {
      for (final item in response['data'] as List) {
        if (item is Map<String, dynamic>) {
          list.add(ScanResultModel.fromJson(item));
        }
      }
    }
    return list;
  }

  @override
  Future<void> sendFeedback(String uuid, bool isAccurate) async {
    await apiClient.post('/scans/$uuid/feedback', body: {
      'is_accurate': isAccurate,
    });
  }
}
