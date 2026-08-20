import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'oval_guide_painter.dart';

class CameraViewfinder extends StatefulWidget {
  final bool isFlashOn;

  const CameraViewfinder({
    super.key,
    this.isFlashOn = false,
  });

  @override
  State<CameraViewfinder> createState() => _CameraViewfinderState();
}

class _CameraViewfinderState extends State<CameraViewfinder> {
  CameraController? _controller;
  bool _isInitialized = false;
  bool _permissionDenied = false;
  String? _initError;

  @override
  void initState() {
    super.initState();
    _requestAndInitializeCamera();
  }

  Future<void> _requestAndInitializeCamera() async {
    try {
      var status = await Permission.camera.status;
      if (!status.isGranted) {
        status = await Permission.camera.request();
      }

      if (status.isGranted || status.isLimited) {
        if (mounted) {
          setState(() {
            _permissionDenied = false;
          });
        }
        await _initializeCamera();
      } else {
        await _initializeCamera();
      }
    } catch (e) {
      await _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        final selectedCamera = cameras.firstWhere(
          (cam) => cam.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first,
        );

        _controller = CameraController(
          selectedCamera,
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isInitialized = true;
            _initError = null;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _initError = 'Kamera tidak ditemukan pada perangkat ini.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _initError = e.toString();
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant CameraViewfinder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlashOn != oldWidget.isFlashOn && _isInitialized && _controller != null) {
      try {
        _controller!.setFlashMode(
          widget.isFlashOn ? FlashMode.torch : FlashMode.off,
        );
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E232A),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Live Camera Preview when camera controller is initialized
            if (_isInitialized && _controller != null)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.previewSize?.height ?? 1,
                  height: _controller!.value.previewSize?.width ?? 1,
                  child: CameraPreview(_controller!),
                ),
              )
            else if (_permissionDenied)
              _buildPermissionDeniedUI()
            else
              _buildFallbackOrErrorUI(),

            // 2. Oval Face / Skin Alignment Guide Overlay
            CustomPaint(
              painter: OvalGuidePainter(
                strokeColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackOrErrorUI() {
    return Container(
      color: const Color(0xFF2A313C),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=800',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: const Color(0xFF2A313C));
            },
          ),
          Container(
            color: Colors.black.withValues(alpha: 0.4),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.camera_alt_rounded,
                  size: 42,
                  color: Colors.white70,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    _initError != null
                        ? 'Harap lakukan Restart/Rebuild aplikasi (flutter run) untuk memuat plugin kamera native HP Anda.'
                        : 'Menyiapkan kamera HP...',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      height: 1.4,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  onPressed: () => _requestAndInitializeCamera(),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: Text(
                    'Coba Lagi',
                    style: GoogleFonts.roboto(fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BF83),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDeniedUI() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: const Color(0xFF1E232A),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF00BF83).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt_rounded,
              size: 36,
              color: Color(0xFF00BF83),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Akses Kamera Diperlukan',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aktifkan izin kamera untuk memindai kondisi kulit secara langsung.',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 12,
              height: 1.4,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BF83),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Buka Pengaturan HP',
              style: GoogleFonts.roboto(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
