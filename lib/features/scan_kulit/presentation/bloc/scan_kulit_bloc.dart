import 'package:flutter_bloc/flutter_bloc.dart';
import 'scan_kulit_event.dart';
import 'scan_kulit_state.dart';

class ScanKulitBloc extends Bloc<ScanKulitEvent, ScanKulitState> {
  ScanKulitBloc() : super(const ScanKulitState()) {
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
    emit(state.copyWith(status: ScanStatus.capturing));
    await Future.delayed(const Duration(milliseconds: 800));
    emit(state.copyWith(
      status: ScanStatus.success,
      imagePath: 'simulated_captured_skin.jpg',
    ));
  }

  Future<void> _onPickFromGallery(
    PickFromGalleryEvent event,
    Emitter<ScanKulitState> emit,
  ) async {
    emit(state.copyWith(status: ScanStatus.capturing));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(
      status: ScanStatus.success,
      imagePath: 'simulated_gallery_skin.jpg',
    ));
  }

  void _onResetScan(
    ResetScanEvent event,
    Emitter<ScanKulitState> emit,
  ) {
    emit(const ScanKulitState(status: ScanStatus.cameraReady));
  }
}
