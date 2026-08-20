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
