import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(String name, {String? gender, String? dateOfBirth});
  Future<ProfileModel> deleteAvatar();
  Future<void> deleteAccount();
  Future<Map<String, dynamic>> exportData();
  Future<void> sendEmailVerificationOtp();
  Future<void> verifyEmailOtp(String otp);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl({ApiClient? apiClient})
      : apiClient = apiClient ?? ApiClientImpl();

  @override
  Future<ProfileModel> getProfile() async {
    final response = await apiClient.get(ApiConstants.profileEndpoint);
    return ProfileModel.fromJson(response);
  }

  @override
  Future<ProfileModel> updateProfile(String name, {String? gender, String? dateOfBirth}) async {
    final body = <String, dynamic>{
      'full_name': name,
    };
    if (gender != null && gender.isNotEmpty) {
      body['gender'] = gender;
    }
    if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
      body['date_of_birth'] = dateOfBirth;
    }

    final response = await apiClient.patch(
      ApiConstants.profileEndpoint,
      body: body,
    );
    return ProfileModel.fromJson(response);
  }

  @override
  Future<ProfileModel> deleteAvatar() async {
    final response = await apiClient.delete('${ApiConstants.profileEndpoint}/avatar');
    return ProfileModel.fromJson(response);
  }

  @override
  Future<void> deleteAccount() async {
    await apiClient.delete(ApiConstants.profileEndpoint);
  }

  @override
  Future<Map<String, dynamic>> exportData() async {
    final response = await apiClient.post('${ApiConstants.profileEndpoint}/export');
    if (response.containsKey('data') && response['data'] is Map<String, dynamic>) {
      return response['data'] as Map<String, dynamic>;
    }
    return response;
  }

  @override
  Future<void> sendEmailVerificationOtp() async {
    await apiClient.post('/email/verify/send');
  }

  @override
  Future<void> verifyEmailOtp(String otp) async {
    await apiClient.post('/email/verify', body: {'otp': otp});
  }
}
