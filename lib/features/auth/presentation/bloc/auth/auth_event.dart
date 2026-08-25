sealed class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({
    required this.email,
    required this.password,
  });
}

class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final bool privacyConsent;

  AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    this.privacyConsent = true,
  });
}

class AuthLogoutRequested extends AuthEvent {}
