import 'package:flutter/foundation.dart';
import '../../domain/entities/scan_result.dart';

enum ScanStatus { initial, loading, cameraReady, capturing, success, failure }

@immutable
class ScanKulitState {
  final ScanStatus status;
  final bool isFlashOn;
  final String? imagePath;
  final String? errorMessage;
  final ScanResult? scanResult;

  const ScanKulitState({
    this.status = ScanStatus.initial,
    this.isFlashOn = false,
    this.imagePath,
    this.errorMessage,
    this.scanResult,
  });

  ScanKulitState copyWith({
    ScanStatus? status,
    bool? isFlashOn,
    String? imagePath,
    String? errorMessage,
    ScanResult? scanResult,
  }) {
    return ScanKulitState(
      status: status ?? this.status,
      isFlashOn: isFlashOn ?? this.isFlashOn,
      imagePath: imagePath ?? this.imagePath,
      errorMessage: errorMessage ?? this.errorMessage,
      scanResult: scanResult ?? this.scanResult,
    );
  }
}
