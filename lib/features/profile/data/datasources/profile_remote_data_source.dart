import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(String name);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileModel _currentProfile = const ProfileModel(
    id: 'user_101',
    name: 'Ahmad User',
    email: 'ahmad.user@example.com',
    bio: 'Pemerhati kesehatan kulit harian.',
  );

  @override
  Future<ProfileModel> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _currentProfile;
  }

  @override
  Future<ProfileModel> updateProfile(String name) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _currentProfile = ProfileModel(
      id: _currentProfile.id,
      name: name,
      email: _currentProfile.email,
      avatarUrl: _currentProfile.avatarUrl,
      bio: _currentProfile.bio,
    );
    return _currentProfile;
  }
}
