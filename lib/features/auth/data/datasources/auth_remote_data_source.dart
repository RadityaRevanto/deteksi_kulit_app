import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    bool privacyConsent = true,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({ApiClient? apiClient})
      : apiClient = apiClient ?? ApiClientImpl();

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      ApiConstants.loginEndpoint,
      body: {
        'email': email,
        'password': password,
      },
    );
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    bool privacyConsent = true,
  }) async {
    final response = await apiClient.post(
      ApiConstants.registerEndpoint,
      body: {
        'full_name': name,
        'email': email,
        'password': password,
        'privacy_consent': privacyConsent,
      },
    );
    return UserModel.fromJson(response);
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.post(ApiConstants.logoutEndpoint);
    } catch (_) {
      // Best-effort logout attempt on server
    }
  }
}
