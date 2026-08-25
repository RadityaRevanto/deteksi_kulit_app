import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  Future<User?> call() async {
    return await repository.getSavedUser();
  }
}
