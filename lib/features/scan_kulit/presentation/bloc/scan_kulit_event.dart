import 'package:flutter/foundation.dart';

@immutable
abstract class ScanKulitEvent {
  const ScanKulitEvent();
}

class InitializeCameraEvent extends ScanKulitEvent {
  const InitializeCameraEvent();
}

class ToggleFlashEvent extends ScanKulitEvent {
  const ToggleFlashEvent();
}

class CaptureImageEvent extends ScanKulitEvent {
  const CaptureImageEvent();
}

class PickFromGalleryEvent extends ScanKulitEvent {
  const PickFromGalleryEvent();
}

class ResetScanEvent extends ScanKulitEvent {
  const ResetScanEvent();
}
