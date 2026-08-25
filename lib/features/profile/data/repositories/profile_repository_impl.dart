import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfile> getProfile() async {
    return await remoteDataSource.getProfile();
  }

  @override
  Future<UserProfile> updateProfile(String name, {String? gender, String? dateOfBirth}) async {
    return await remoteDataSource.updateProfile(name, gender: gender, dateOfBirth: dateOfBirth);
  }

  @override
  Future<UserProfile> deleteAvatar() async {
    return await remoteDataSource.deleteAvatar();
  }

  @override
  Future<void> deleteAccount() async {
    await remoteDataSource.deleteAccount();
  }

  @override
  Future<Map<String, dynamic>> exportData() async {
    return await remoteDataSource.exportData();
  }
}
