import '../../../../core/network/api_client.dart';
import '../models/doctor_model.dart';

abstract class DoctorRemoteDataSource {
  Future<List<DoctorModel>> getDoctors();
}

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  final ApiClient apiClient;

  DoctorRemoteDataSourceImpl({ApiClient? apiClient})
      : apiClient = apiClient ?? ApiClientImpl();

  @override
  Future<List<DoctorModel>> getDoctors() async {
    try {
      final response = await apiClient.get('/doctors?per_page=20');
      final list = <DoctorModel>[];

      if (response.containsKey('data') && response['data'] is List) {
        for (final item in response['data'] as List) {
          if (item is Map<String, dynamic>) {
            list.add(DoctorModel.fromJson(item));
          }
        }
      }
      return list;
    } catch (_) {
      return [];
    }
  }
}
