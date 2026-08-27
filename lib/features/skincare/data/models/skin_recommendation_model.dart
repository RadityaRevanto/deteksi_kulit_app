import '../../../dokter/data/models/doctor_model.dart';
import '../../domain/entities/skin_recommendation.dart';
import 'skin_concern_model.dart';
import 'skincare_product_model.dart';

class SkinRecommendationModel extends SkinRecommendation {
  const SkinRecommendationModel({
    required super.uuid,
    required super.title,
    required super.recommendationText,
    required super.priorityLevel,
    required super.isActive,
    super.concern,
    super.product,
    super.doctor,
    required super.createdAt,
  });

  factory SkinRecommendationModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.now();
    try {
      if (json['created_at'] != null) {
        parsedDate = DateTime.parse(json['created_at'].toString());
      }
    } catch (_) {}

    return SkinRecommendationModel(
      uuid: json['uuid']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      recommendationText: json['recommendation_text']?.toString() ?? '',
      priorityLevel: json['priority_level']?.toString() ?? 'medium',
      isActive: json['is_active'] == true || json['is_active'] == 1,
      concern: json['concern'] != null && json['concern'] is Map<String, dynamic>
          ? SkinConcernModel.fromJson(json['concern'])
          : null,
      product: json['product'] != null && json['product'] is Map<String, dynamic>
          ? SkincareProductModel.fromJson(json['product'])
          : null,
      doctor: json['doctor'] != null && json['doctor'] is Map<String, dynamic>
          ? DoctorModel.fromJson(json['doctor'])
          : null,
      createdAt: parsedDate,
    );
  }
}
