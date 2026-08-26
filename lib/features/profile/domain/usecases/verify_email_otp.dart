import '../repositories/profile_repository.dart';

class VerifyEmailOtp {
  final ProfileRepository repository;

  VerifyEmailOtp(this.repository);

  Future<void> call(String otp) async {
    await repository.verifyEmailOtp(otp);
  }
}
