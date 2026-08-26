import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/scan_result.dart';
import '../../domain/usecases/perform_scan_upload.dart';
import 'scan_kulit_event.dart';
import 'scan_kulit_state.dart';

class ScanKulitBloc extends Bloc<ScanKulitEvent, ScanKulitState> {
  final PerformScanUpload performScanUpload;
  final ImagePicker _picker;

  ScanKulitBloc({
    required this.performScanUpload,
    ImagePicker? picker,
  })  : _picker = picker ?? ImagePicker(),
        super(const ScanKulitState()) {
    on<InitializeCameraEvent>(_onInitializeCamera);
    on<ToggleFlashEvent>(_onToggleFlash);
    on<CaptureImageEvent>(_onCaptureImage);
    on<PickFromGalleryEvent>(_onPickFromGallery);
    on<ResetScanEvent>(_onResetScan);
  }

  void _onInitializeCamera(
    InitializeCameraEvent event,
    Emitter<ScanKulitState> emit,
  ) {
    emit(state.copyWith(status: ScanStatus.cameraReady));
  }

  void _onToggleFlash(
    ToggleFlashEvent event,
    Emitter<ScanKulitState> emit,
  ) {
    emit(state.copyWith(isFlashOn: !state.isFlashOn));
  }

  Future<void> _onCaptureImage(
    CaptureImageEvent event,
    Emitter<ScanKulitState> emit,
  ) async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo == null) return;

      emit(state.copyWith(status: ScanStatus.capturing));

      final file = File(photo.path);
      final result = await performScanUpload(file);

      final finalResult = (result.imageUrl == null || result.imageUrl!.isEmpty)
          ? ScanResult(
              uuid: result.uuid,
              scanMode: result.scanMode,
              predictedClass: result.predictedClass,
              confidence: result.confidence,
              probabilities: result.probabilities,
              severityScore: result.severityScore,
              severityLevel: result.severityLevel,
              modelUsed: result.modelUsed,
              imageUrl: photo.path,
              disclaimer: result.disclaimer,
              notice: result.notice,
              createdAt: result.createdAt,
            )
          : result;

      emit(state.copyWith(
        status: ScanStatus.success,
        imagePath: photo.path,
        scanResult: finalResult,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ScanStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onPickFromGallery(
    PickFromGalleryEvent event,
    Emitter<ScanKulitState> emit,
  ) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      emit(state.copyWith(status: ScanStatus.capturing));

      final file = File(image.path);
      final result = await performScanUpload(file);

      final finalResult = (result.imageUrl == null || result.imageUrl!.isEmpty)
          ? ScanResult(
              uuid: result.uuid,
              scanMode: result.scanMode,
              predictedClass: result.predictedClass,
              confidence: result.confidence,
              probabilities: result.probabilities,
              severityScore: result.severityScore,
              severityLevel: result.severityLevel,
              modelUsed: result.modelUsed,
              imageUrl: image.path,
              disclaimer: result.disclaimer,
              notice: result.notice,
              createdAt: result.createdAt,
            )
          : result;

      emit(state.copyWith(
        status: ScanStatus.success,
        imagePath: image.path,
        scanResult: finalResult,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ScanStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  void _onResetScan(
    ResetScanEvent event,
    Emitter<ScanKulitState> emit,
  ) {
    emit(const ScanKulitState(status: ScanStatus.cameraReady));
  }
}
