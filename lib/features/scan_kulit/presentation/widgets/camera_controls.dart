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
      ],
    );
  }
}
