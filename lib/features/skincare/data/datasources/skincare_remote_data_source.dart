import '../../../../core/network/api_client.dart';
import '../models/skin_concern_model.dart';
import '../models/skin_recommendation_model.dart';
import '../models/skin_type_model.dart';
import '../models/skincare_product_model.dart';

abstract class SkincareRemoteDataSource {
  Future<List<SkincareProductModel>> getSkincareProducts({
    String? concernUuid,
    String? skinTypeUuid,
    String? gender,
    int page = 1,
    int perPage = 20,
  });

  Future<SkincareProductModel> getSkincareProductDetail(String productUuid);

  Future<List<SkinRecommendationModel>> getSkinRecommendations({
    String? mlLabel,
    String? concernId,
    int page = 1,
    int perPage = 10,
  });

  Future<List<SkinConcernModel>> getSkinConcerns();

  Future<List<SkinTypeModel>> getSkinTypes();
}

class SkincareRemoteDataSourceImpl implements SkincareRemoteDataSource {
  final ApiClient apiClient;

  SkincareRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<SkincareProductModel>> getSkincareProducts({
    String? concernUuid,
    String? skinTypeUuid,
    String? gender,
    int page = 1,
    int perPage = 20,
  }) async {
    final queryParams = <String, String>{
      'per_page': perPage.toString(),
      'page': page.toString(),
    };
    if (concernUuid != null && concernUuid.isNotEmpty) {
      queryParams['concern'] = concernUuid;
    }
    if (skinTypeUuid != null && skinTypeUuid.isNotEmpty) {
      queryParams['skin_type'] = skinTypeUuid;
    }
    if (gender != null && gender.isNotEmpty) {
      queryParams['gender'] = gender;
    }

    final uri = Uri(path: '/skincare-products', queryParameters: queryParams);
    final response = await apiClient.get(uri.toString());

    final dataList = response['data'] as List<dynamic>? ?? [];
    return dataList
        .map((item) => SkincareProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<SkincareProductModel> getSkincareProductDetail(String productUuid) async {
    final response = await apiClient.get('/skincare-products/$productUuid');
    final data = response['data'] as Map<String, dynamic>;
    return SkincareProductModel.fromJson(data);
  }

  @override
  Future<List<SkinRecommendationModel>> getSkinRecommendations({
    String? mlLabel,
    String? concernId,
    int page = 1,
    int perPage = 10,
  }) async {
    final queryParams = <String, String>{
      'per_page': perPage.toString(),
      'page': page.toString(),
    };
    if (mlLabel != null && mlLabel.isNotEmpty) {
      queryParams['ml_label'] = mlLabel;
    }
    if (concernId != null && concernId.isNotEmpty) {
      queryParams['concern_id'] = concernId;
    }

    final uri = Uri(path: '/skin-recommendations', queryParameters: queryParams);
    final response = await apiClient.get(uri.toString());

    final dataList = response['data'] as List<dynamic>? ?? [];
    return dataList
        .map((item) => SkinRecommendationModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<SkinConcernModel>> getSkinConcerns() async {
    final response = await apiClient.get('/skin-concerns');
    final dataList = response['data'] as List<dynamic>? ?? [];
    return dataList
        .map((item) => SkinConcernModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<SkinTypeModel>> getSkinTypes() async {
    final response = await apiClient.get('/skin-types');
    final dataList = response['data'] as List<dynamic>? ?? [];
    return dataList
        .map((item) => SkinTypeModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
