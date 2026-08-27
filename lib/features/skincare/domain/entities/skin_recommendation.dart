import '../../../dokter/domain/entities/doctor.dart';
import 'skin_concern.dart';
import 'skincare_product.dart';

class SkinRecommendation {
  final String uuid;
  final String title;
  final String recommendationText;
  final String priorityLevel;
  final bool isActive;
  final SkinConcern? concern;
  final SkincareProduct? product;
  final Doctor? doctor;
  final DateTime createdAt;

  const SkinRecommendation({
    required this.uuid,
    required this.title,
    required this.recommendationText,
    required this.priorityLevel,
    required this.isActive,
    this.concern,
    this.product,
    this.doctor,
    required this.createdAt,
  });
}
