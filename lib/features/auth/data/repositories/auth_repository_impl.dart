import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final userModel = await remoteDataSource.login(email: email, password: password);
    if (userModel.token != null && userModel.token!.isNotEmpty) {
      await localDataSource.saveToken(userModel.token!);
    }
    await localDataSource.saveUser(userModel);
    return userModel;
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
    bool privacyConsent = true,
  }) async {
    final userModel = await remoteDataSource.register(
      name: name,
      email: email,
      password: password,
      privacyConsent: privacyConsent,
    );
    if (userModel.token != null && userModel.token!.isNotEmpty) {
      await localDataSource.saveToken(userModel.token!);
    }
    await localDataSource.saveUser(userModel);
    return userModel;
  }

  @override
  Future<User?> getSavedUser() async {
    final token = await localDataSource.getToken();
    if (token == null || token.isEmpty) {
      return null;
    }
    return await localDataSource.getUser();
  }

  @override
  Future<String?> getToken() async {
    return await localDataSource.getToken();
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
    await localDataSource.clearSession();
  }
}
