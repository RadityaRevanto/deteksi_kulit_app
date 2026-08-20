import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  Future<UserProfile> call(String name) async {
    return await repository.updateProfile(name);
  }
}
