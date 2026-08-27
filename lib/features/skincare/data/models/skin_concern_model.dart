import '../../domain/entities/skin_concern.dart';

class SkinConcernModel extends SkinConcern {
  const SkinConcernModel({
    required super.uuid,
    required super.name,
    required super.mlLabel,
    required super.description,
    required super.defaultSeverityScore,
    required super.isActive,
  });

  factory SkinConcernModel.fromJson(Map<String, dynamic> json) {
    return SkinConcernModel(
      uuid: json['uuid']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      mlLabel: json['ml_label']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      defaultSeverityScore: int.tryParse(json['default_severity_score']?.toString() ?? '50') ?? 50,
      isActive: json['is_active'] == true || json['is_active'] == 1,
    );
  }
}
