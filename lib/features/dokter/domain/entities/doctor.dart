class Doctor {
  final String id;
  final String name;
  final String specialist;
  final String hospital;
  final double rating;
  final int reviewCount;
  final int experienceYears;
  final int consultationFee;
  final bool isOnline;
  final String avatarUrl;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialist,
    required this.hospital,
    required this.rating,
    required this.reviewCount,
    required this.experienceYears,
    required this.consultationFee,
    required this.isOnline,
    required this.avatarUrl,
  });
}
