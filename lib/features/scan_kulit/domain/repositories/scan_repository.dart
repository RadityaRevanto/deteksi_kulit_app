import 'dart:io';

import '../entities/scan_result.dart';

abstract class ScanRepository {
  Future<ScanResult> uploadScan(File imageFile);
  Future<ScanResult> livecamScan(File imageFile);
  Future<List<ScanResult>> getScanHistory();
  Future<void> sendFeedback(String uuid, bool isAccurate);
}
