import '../../domain/entities/skin_type.dart';

class SkinTypeModel extends SkinType {
  const SkinTypeModel({
    required super.uuid,
    required super.name,
    required super.description,
    required super.isActive,
  });

  factory SkinTypeModel.fromJson(Map<String, dynamic> json) {
    return SkinTypeModel(
      uuid: json['uuid']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      isActive: json['is_active'] == true || json['is_active'] == 1,
    );
  }
}
