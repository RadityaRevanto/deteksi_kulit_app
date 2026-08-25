import '../../domain/entities/user_profile.dart';

class ProfileModel extends UserProfile {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.role = 'user',
    super.avatarUrl,
    super.dateOfBirth,
    super.gender,
    super.profileCompleted = false,
    super.emailVerified = false,
    super.subscriptionStatus = 'Free',
    super.scanCount = 0,
    super.userMessagesCount = 0,
    super.remainingFreeMessages = 3,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>) ? json['data'] as Map<String, dynamic> : json;

    return ProfileModel(
      id: (data['uuid'] ?? data['id'] ?? '') as String,
      name: (data['full_name'] ?? data['name'] ?? '') as String,
      email: (data['email'] ?? '') as String,
      role: (data['role'] ?? 'user') as String,
      avatarUrl: data['avatar_url'] as String? ?? data['google_avatar_url'] as String?,
      dateOfBirth: data['date_of_birth'] as String?,
      gender: data['gender'] as String?,
      profileCompleted: (data['profile_completed'] as bool?) ?? false,
      emailVerified: (data['email_verified'] as bool?) ?? false,
      subscriptionStatus: (data['subscription_status'] ?? 'Free') as String,
      scanCount: (data['scan_count'] as num?)?.toInt() ?? 0,
      userMessagesCount: (data['user_messages_count'] as num?)?.toInt() ?? 0,
      remainingFreeMessages: (data['remaining_free_messages'] as num?)?.toInt() ?? 3,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': id,
      'full_name': name,
      'email': email,
      'role': role,
      'avatar_url': avatarUrl,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'profile_completed': profileCompleted,
      'email_verified': emailVerified,
      'subscription_status': subscriptionStatus,
      'scan_count': scanCount,
      'user_messages_count': userMessagesCount,
      'remaining_free_messages': remainingFreeMessages,
    };
  }
}
