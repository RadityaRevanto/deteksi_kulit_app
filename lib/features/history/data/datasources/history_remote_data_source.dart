import '../models/history_model.dart';

abstract class HistoryRemoteDataSource {
  Future<List<HistoryModel>> getHistories();
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  @override
  Future<List<HistoryModel>> getHistories() async {
    // Simulasi delay jaringan dan data mock
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      HistoryModel(
        id: '1',
        conditionName: 'Eksim (Eczema)',
        confidence: 0.94,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      HistoryModel(
        id: '2',
        conditionName: 'Jerawat (Acne Vulgaris)',
        confidence: 0.88,
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
      HistoryModel(
        id: '3',
        conditionName: 'Psoriasis',
        confidence: 0.79,
        date: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];
  }
}
