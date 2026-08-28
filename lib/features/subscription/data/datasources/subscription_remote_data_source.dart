import '../../../../core/network/api_client.dart';
import '../models/subscription_model.dart';

abstract class SubscriptionRemoteDataSource {
  Future<CheckoutResultModel> checkout();
  Future<List<SubscriptionModel>> getSubscriptions();
  Future<SubscriptionModel> getReceipt(String uuid);
  Future<void> cancelSubscription(String uuid);
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  final ApiClient apiClient;

  SubscriptionRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CheckoutResultModel> checkout() async {
    final response = await apiClient.post('/subscriptions/checkout');
    final data = response['data'] as Map<String, dynamic>;
    return CheckoutResultModel.fromJson(data);
  }

  @override
  Future<List<SubscriptionModel>> getSubscriptions() async {
    final response = await apiClient.get('/subscriptions');
    final dataList = response['data'] as List<dynamic>? ?? [];
    return dataList
        .map((item) => SubscriptionModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<SubscriptionModel> getReceipt(String uuid) async {
    final response = await apiClient.get('/subscriptions/$uuid/receipt');
    final data = response['data'] as Map<String, dynamic>;
    return SubscriptionModel.fromJson(data);
  }

  @override
  Future<void> cancelSubscription(String uuid) async {
    await apiClient.post('/subscriptions/$uuid/cancel');
  }
}
