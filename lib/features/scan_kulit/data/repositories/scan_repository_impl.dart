import 'dart:io';

import '../../domain/entities/scan_result.dart';
import '../../domain/repositories/scan_repository.dart';
import '../datasources/scan_remote_data_source.dart';

class ScanRepositoryImpl implements ScanRepository {
  final ScanRemoteDataSource remoteDataSource;

  ScanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ScanResult> uploadScan(File imageFile) async {
    return await remoteDataSource.uploadScan(imageFile);
  }

  @override
  Future<ScanResult> livecamScan(File imageFile) async {
    return await remoteDataSource.livecamScan(imageFile);
  }

  @override
  Future<List<ScanResult>> getScanHistory() async {
    return await remoteDataSource.getScanHistory();
  }

  @override
  Future<void> sendFeedback(String uuid, bool isAccurate) async {
    await remoteDataSource.sendFeedback(uuid, isAccurate);
  }
}
