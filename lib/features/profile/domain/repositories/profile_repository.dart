import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile(String name, {String? gender, String? dateOfBirth});
  Future<UserProfile> deleteAvatar();
  Future<void> deleteAccount();
  Future<Map<String, dynamic>> exportData();
  Future<void> sendEmailVerificationOtp();
  Future<void> verifyEmailOtp(String otp);
}
