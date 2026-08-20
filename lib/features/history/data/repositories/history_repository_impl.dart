import '../../domain/entities/history.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_remote_data_source.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;

  HistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<History>> getHistories() async {
    final historyModels = await remoteDataSource.getHistories();
    return historyModels;
  }
}
