import '../../domain/entities/scan_result.dart';

class ScanResultModel extends ScanResult {
  const ScanResultModel({
    required super.uuid,
    required super.scanMode,
    required super.predictedClass,
    required super.confidence,
    required super.probabilities,
    required super.severityScore,
    required super.severityLevel,
    required super.modelUsed,
    super.imageUrl,
    required super.disclaimer,
    super.notice,
    required super.createdAt,
  });

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    final rawData = (json.containsKey('data') && json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    final probsMap = <String, double>{};
    if (rawData['probabilities'] is Map) {
      (rawData['probabilities'] as Map).forEach((key, val) {
        probsMap[key.toString()] = (val is num) ? val.toDouble() : 0.0;
      });
    }

    return ScanResultModel(
      uuid: rawData['uuid']?.toString() ?? '',
      scanMode: rawData['scan_mode']?.toString() ?? 'upload',
      predictedClass: rawData['predicted_class']?.toString() ?? 'unknown',
      confidence: (rawData['confidence'] is num) ? (rawData['confidence'] as num).toDouble() : 0.0,
      probabilities: probsMap,
      severityScore: (rawData['severity_score'] is num) ? (rawData['severity_score'] as num).toInt() : 0,
      severityLevel: rawData['severity_level']?.toString() ?? 'medium',
      modelUsed: rawData['model_used']?.toString() ?? 'skin-model-v1',
      imageUrl: rawData['image_url']?.toString(),
      disclaimer: rawData['disclaimer']?.toString() ??
          'Hasil scan hanya sebagai referensi awal dan bukan diagnosis medis.',
      notice: rawData['notice']?.toString(),
      createdAt: rawData['created_at']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }
}
