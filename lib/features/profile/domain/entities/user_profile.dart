class UserProfile {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;
  final String? dateOfBirth;
  final String? gender;
  final bool profileCompleted;
  final bool emailVerified;
  final String subscriptionStatus;
  final int scanCount;
  final int userMessagesCount;
  final int remainingFreeMessages;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'user',
    this.avatarUrl,
    this.dateOfBirth,
    this.gender,
    this.profileCompleted = false,
    this.emailVerified = false,
    this.subscriptionStatus = 'Free',
    this.scanCount = 0,
    this.userMessagesCount = 0,
    this.remainingFreeMessages = 3,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? avatarUrl,
    String? dateOfBirth,
    String? gender,
    bool? profileCompleted,
    bool? emailVerified,
    String? subscriptionStatus,
    int? scanCount,
    int? userMessagesCount,
    int? remainingFreeMessages,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      emailVerified: emailVerified ?? this.emailVerified,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      scanCount: scanCount ?? this.scanCount,
      userMessagesCount: userMessagesCount ?? this.userMessagesCount,
      remainingFreeMessages: remainingFreeMessages ?? this.remainingFreeMessages,
    );
  }
}
