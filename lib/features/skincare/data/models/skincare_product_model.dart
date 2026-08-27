import '../../../dokter/data/models/doctor_model.dart';
import '../../domain/entities/skincare_product.dart';
import 'skin_concern_model.dart';
import 'skin_type_model.dart';

class SkincareProductModel extends SkincareProduct {
  const SkincareProductModel({
    required super.uuid,
    required super.name,
    required super.category,
    required super.gender,
    required super.keyIngredients,
    required super.usageInstruction,
    super.warning,
    required super.isActive,
    super.concern,
    super.skinType,
    super.doctor,
  });

  factory SkincareProductModel.fromJson(Map<String, dynamic> json) {
    return SkincareProductModel(
      uuid: json['uuid']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Skincare',
      gender: json['gender']?.toString() ?? 'unisex',
      keyIngredients: json['key_ingredients']?.toString() ?? '',
      usageInstruction: json['usage_instruction']?.toString() ?? '',
      warning: json['warning']?.toString(),
      isActive: json['is_active'] == true || json['is_active'] == 1,
      concern: json['concern'] != null && json['concern'] is Map<String, dynamic>
          ? SkinConcernModel.fromJson(json['concern'])
          : null,
      skinType: json['skin_type'] != null && json['skin_type'] is Map<String, dynamic>
          ? SkinTypeModel.fromJson(json['skin_type'])
          : null,
      doctor: json['doctor'] != null && json['doctor'] is Map<String, dynamic>
          ? DoctorModel.fromJson(json['doctor'])
          : null,
    );
  }
}
