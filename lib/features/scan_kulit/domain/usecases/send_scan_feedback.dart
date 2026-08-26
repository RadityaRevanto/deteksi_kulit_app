import '../repositories/scan_repository.dart';

class SendScanFeedback {
  final ScanRepository repository;

  SendScanFeedback(this.repository);

  Future<void> call(String uuid, bool isAccurate) async {
    await repository.sendFeedback(uuid, isAccurate);
  }
}
