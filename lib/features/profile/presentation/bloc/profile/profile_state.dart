import '../../../domain/entities/user_profile.dart';

sealed class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  ProfileLoaded(this.profile);
}

class ProfileFailure extends ProfileState {
  final String message;

  ProfileFailure(this.message);
}

class ProfileAccountDeletedSuccess extends ProfileState {}

class ProfileDataExportSuccess extends ProfileState {
  final String downloadUrl;
  final int expiresInMinutes;

  ProfileDataExportSuccess({
    required this.downloadUrl,
    required this.expiresInMinutes,
  });
}

class EmailOtpSentSuccess extends ProfileState {
  final String message;

  EmailOtpSentSuccess(this.message);
}

class EmailVerificationSuccess extends ProfileState {
  final String message;

  EmailVerificationSuccess(this.message);
}
