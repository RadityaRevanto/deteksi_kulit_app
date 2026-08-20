sealed class ProfileEvent {}

class ProfileRequested extends ProfileEvent {}

class ProfileUpdated extends ProfileEvent {
  final String name;

  ProfileUpdated(this.name);
}
