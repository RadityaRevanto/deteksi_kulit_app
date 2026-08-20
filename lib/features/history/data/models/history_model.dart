import '../../domain/entities/history.dart';

class HistoryModel extends History {
  const HistoryModel({
    required super.id,
    required super.conditionName,
    required super.confidence,
    required super.date,
    super.imageUrl,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'] as String,
      conditionName: json['conditionName'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      imageUrl: json['imageUrl'] as String?,
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
