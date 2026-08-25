import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class DeleteAvatar {
  final ProfileRepository repository;

  DeleteAvatar(this.repository);

  Future<UserProfile> call() async {
    return await repository.deleteAvatar();
  }
}
