import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PrivacyBanner extends StatelessWidget {
  const PrivacyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FBF7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00BF83).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF00BF83).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.shieldCheck,
              size: 20,
              color: Color(0xFF008D68),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Foto kamu aman dan hanya digunakan untuk analisis kulit.',
              style: GoogleFonts.roboto(
                fontSize: 11,
                height: 1.4,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF2A5044),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
