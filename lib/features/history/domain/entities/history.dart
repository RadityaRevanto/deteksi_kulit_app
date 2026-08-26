import '../../../scan_kulit/domain/entities/scan_result.dart';

class History {
  final String id;
  final String conditionName;
  final double confidence;
  final DateTime date;
  final String? imageUrl;
  final ScanResult? scanResult;

  const History({
    required this.id,
    required this.conditionName,
    required this.confidence,
    required this.date,
    this.imageUrl,
    this.scanResult,
  });
}
