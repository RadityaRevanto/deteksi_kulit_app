import '../../domain/entities/doctor.dart';

class DoctorModel extends Doctor {
  const DoctorModel({
    required super.id,
    required super.name,
    super.title,
    required super.specialist,
    required super.hospital,
    required super.rating,
    required super.reviewCount,
    required super.experienceYears,
    required super.consultationFee,
    required super.isOnline,
    required super.avatarUrl,
    super.isAiBot = false,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    final fullName = json['full_name']?.toString() ?? json['name']?.toString() ?? 'Dokter';
    final title = json['title']?.toString();
    final nameWithTitle = (title != null && title.isNotEmpty) ? '$fullName, $title' : fullName;

    final ratingVal = (json['rating_avg'] is num)
        ? (json['rating_avg'] as num).toDouble()
        : ((json['rating'] is num) ? (json['rating'] as num).toDouble() : 4.8);

    final ratingCountVal = (json['rating_count'] is num)
        ? (json['rating_count'] as num).toInt()
        : ((json['reviewCount'] is num) ? (json['reviewCount'] as num).toInt() : 12);

    final isAi = json['is_ai_bot'] == true;

    return DoctorModel(
      id: json['uuid']?.toString() ?? json['id']?.toString() ?? '',
      name: nameWithTitle,
      title: title,
      specialist: json['specialization']?.toString() ?? json['specialist']?.toString() ?? 'Spesialis Kulit',
      hospital: isAi ? 'Aura Skin AI Assistant' : (json['hospital']?.toString() ?? 'Klinik SkinCek Utama'),
      rating: ratingVal,
      reviewCount: ratingCountVal,
      experienceYears: (json['experience_years'] is num) ? (json['experience_years'] as num).toInt() : 5,
      consultationFee: isAi ? 0 : 50000,
      isOnline: true,
      avatarUrl: json['avatar']?.toString() ?? json['avatar_url']?.toString() ?? '',
      isAiBot: isAi,
    );
  }
}
