class ScanResult {
  final String uuid;
  final String scanMode;
  final String predictedClass;
  final double confidence;
  final Map<String, double> probabilities;
  final int severityScore;
  final String severityLevel;
  final String modelUsed;
  final String? imageUrl;
  final String disclaimer;
  final String? notice;
  final String createdAt;

  const ScanResult({
    required this.uuid,
    required this.scanMode,
    required this.predictedClass,
    required this.confidence,
    required this.probabilities,
    required this.severityScore,
    required this.severityLevel,
    required this.modelUsed,
    this.imageUrl,
    required this.disclaimer,
    this.notice,
    required this.createdAt,
  });
}
