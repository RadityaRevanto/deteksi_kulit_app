sealed class ProfileEvent {}

class ProfileRequested extends ProfileEvent {}

class ProfileUpdated extends ProfileEvent {
  final String name;
  final String? gender;
  final String? dateOfBirth;

  ProfileUpdated({
    required this.name,
    this.gender,
    this.dateOfBirth,
  });
}

class ProfileAvatarDeleted extends ProfileEvent {}

class ProfileAccountDeleted extends ProfileEvent {}

class ProfileDataExportRequested extends ProfileEvent {}
