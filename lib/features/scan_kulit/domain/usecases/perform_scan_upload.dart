import 'dart:io';

import '../entities/scan_result.dart';
import '../repositories/scan_repository.dart';

class PerformScanUpload {
  final ScanRepository repository;

  PerformScanUpload(this.repository);

  Future<ScanResult> call(File imageFile) async {
    return await repository.uploadScan(imageFile);
  }
}
