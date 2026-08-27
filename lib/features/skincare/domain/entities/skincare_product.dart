import '../../../dokter/domain/entities/doctor.dart';
import 'skin_concern.dart';
import 'skin_type.dart';

class SkincareProduct {
  final String uuid;
  final String name;
  final String category;
  final String gender;
  final String keyIngredients;
  final String usageInstruction;
  final String? warning;
  final bool isActive;
  final SkinConcern? concern;
  final SkinType? skinType;
  final Doctor? doctor;

  const SkincareProduct({
    required this.uuid,
    required this.name,
    required this.category,
    required this.gender,
    required this.keyIngredients,
    required this.usageInstruction,
    this.warning,
    required this.isActive,
    this.concern,
    this.skinType,
    this.doctor,
  });
}
