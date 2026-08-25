import '../repositories/profile_repository.dart';

class ExportProfileData {
  final ProfileRepository repository;

  ExportProfileData(this.repository);

  Future<Map<String, dynamic>> call() async {
    return await repository.exportData();
  }
}
