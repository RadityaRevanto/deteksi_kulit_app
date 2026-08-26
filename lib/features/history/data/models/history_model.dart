import '../../../scan_kulit/data/models/scan_result_model.dart';
import '../../domain/entities/history.dart';

class HistoryModel extends History {
  const HistoryModel({
    required super.id,
    required super.conditionName,
    required super.confidence,
    required super.date,
    super.imageUrl,
    super.scanResult,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    final scanResultModel = ScanResultModel.fromJson(json);
    DateTime parsedDate = DateTime.now();
    try {
      if (json['created_at'] != null) {
        parsedDate = DateTime.parse(json['created_at'].toString());
      }
    } catch (_) {}

    return HistoryModel(
      id: scanResultModel.uuid,
      conditionName: scanResultModel.predictedClass,
      confidence: scanResultModel.confidence,
      date: parsedDate,
      imageUrl: scanResultModel.imageUrl,
      scanResult: scanResultModel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conditionName': conditionName,
      'confidence': confidence,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }
}
