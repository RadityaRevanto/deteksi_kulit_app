import 'package:flutter/material.dart';

class CameraControls extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCaptureTap;
  final VoidCallback onFlashTap;
  final bool isFlashOn;
  final bool isCapturing;

  const CameraControls({
    super.key,
    required this.onGalleryTap,
    required this.onCaptureTap,
    required this.onFlashTap,
    this.isFlashOn = false,
    this.isCapturing = false,
  });

  static const Color primaryGreen = Color(0xFF00BF83);
  static const Color darkGreen = Color(0xFF008D68);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Gallery Button
        InkWell(
          onTap: isCapturing ? null : onGalleryTap,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE6F8F2),
              border: Border.all(
                color: primaryGreen.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.photo_library_rounded,
              color: darkGreen,
              size: 24,
            ),
          ),
        ),

        // 2. Camera Shutter Capture Button
        GestureDetector(
          onTap: isCapturing ? null : onCaptureTap,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: darkGreen,
                width: 3.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryGreen,
                ),
                child: isCapturing
                    ? const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ),

        // 3. Flash Toggle Button
        InkWell(
          onTap: isCapturing ? null : onFlashTap,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFlashOn ? const Color(0xFFFEF08A) : const Color(0xFFF1F5F9),
              border: Border.all(
                color: isFlashOn ? const Color(0xFFEAB308) : const Color(0xFFCBD5E1),
                width: 1.5,
              ),
            ),
            child: Icon(
              isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
              color: isFlashOn ? const Color(0xFF854D0E) : const Color(0xFF64748B),
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}
