import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ScanSummaryBanner extends StatelessWidget {
  final String conditionName;
  final String confidencePercentage;

  const ScanSummaryBanner({
    super.key,
    this.conditionName = 'Acne / Jerawat',
    this.confidencePercentage = '87%',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F8F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00BF83).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFF00BF83),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.fileText,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Lampiran Hasil AI',
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF008D68),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00BF83),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        confidencePercentage,
                        style: GoogleFonts.roboto(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  conditionName,
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF151918),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Hasil scan ini akan dilampirkan otomatis ke dokter.',
                  style: GoogleFonts.roboto(
                    fontSize: 11,
                    color: const Color(0xFF7B8581),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
