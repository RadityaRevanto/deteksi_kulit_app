import '../repositories/profile_repository.dart';

class SendEmailVerificationOtp {
  final ProfileRepository repository;

  SendEmailVerificationOtp(this.repository);

  Future<void> call() async {
    await repository.sendEmailVerificationOtp();
  }
}
