import '../entities/history.dart';
import '../repositories/history_repository.dart';

class GetHistory {
  final HistoryRepository repository;

  GetHistory(this.repository);

  Future<List<History>> call() async {
    return await repository.getHistories();
  }
}
