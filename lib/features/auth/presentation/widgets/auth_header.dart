import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  static const Color primaryGreen = Color(0xFF00BF83);
  static const Color darkGreen = Color(0xFF008D68);
  static const Color textColor = Color(0xFF151918);
  static const Color secondaryTextColor = Color(0xFF7B8581);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF0FBF7),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0x1F00BF83)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: -0.45,
                child: const Icon(
                  Icons.eco_rounded,
                  color: primaryGreen,
                  size: 29,
                ),
              ),

              Positioned(
                right: 7,
                bottom: 7,
                child: Transform.rotate(
                  angle: 0.55,
                  child: const Icon(
                    Icons.eco_rounded,
                    color: darkGreen,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Skin Detection',
              style: GoogleFonts.roboto(
                fontSize: 16,
                height: 1.2,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: primaryGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Analisis Kulit Berbasis AI',
                  style: GoogleFonts.roboto(
                    fontSize: 11,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
