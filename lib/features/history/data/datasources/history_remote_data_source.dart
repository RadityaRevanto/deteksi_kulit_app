import '../../../../core/network/api_client.dart';
import '../models/history_model.dart';

abstract class HistoryRemoteDataSource {
  Future<List<HistoryModel>> getHistories();
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final ApiClient apiClient;

  HistoryRemoteDataSourceImpl({ApiClient? apiClient})
      : apiClient = apiClient ?? ApiClientImpl();

  @override
  Future<List<HistoryModel>> getHistories() async {
    final response = await apiClient.get('/scans?sort=-created_at');
    final list = <HistoryModel>[];

    if (response.containsKey('data') && response['data'] is List) {
      for (final item in response['data'] as List) {
        if (item is Map<String, dynamic>) {
          list.add(HistoryModel.fromJson(item));
        }
      }
    }
    return list;
  }
}
