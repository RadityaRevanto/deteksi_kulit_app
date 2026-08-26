import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Kartu Ringkasan AI, Saran Awal & Disclaimer
class AiSummaryCard extends StatelessWidget {
  final String? summaryText;
  final String? disclaimer;
  final String? notice;

  const AiSummaryCard({
    super.key,
    this.summaryText,
    this.disclaimer,
    this.notice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (notice != null && notice!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFAEB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFEDF89)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.alertTriangle, size: 18, color: Color(0xFFB54708)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      notice!,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: const Color(0xFFB54708),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Section 1: Ringkasan AI
          Text(
            'Ringkasan AI',
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF151918),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            summaryText ?? 'Terdeteksi indikasi masalah kulit berdasarkan analisis komprehensif model AI.',
            style: GoogleFonts.roboto(
              fontSize: 13,
              height: 1.45,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 18),

          // Section 2: Saran Awal
          Text(
            'Saran Awal',
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF151918),
            ),
          ),
          const SizedBox(height: 10),
          const _CheckItem(text: 'Bersihkan area kulit 2x sehari dengan pembersih lembut'),
          const SizedBox(height: 8),
          const _CheckItem(text: 'Gunakan pelembap dan sunscreen non-komedogenik'),
          const SizedBox(height: 8),
          const _CheckItem(text: 'Hindari memencet atau menggaruk area kulit yang bermasalah'),
          const SizedBox(height: 18),

          // Section 3: Disclaimer Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F8FA),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              disclaimer ??
                  'Hasil scan ini hanya sebagai referensi awal dan bukan diagnosis medis resmi. Konsultasikan ke dokter untuk penanganan medis tepat.',
              style: GoogleFonts.roboto(
                fontSize: 11,
                height: 1.45,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF7B8581),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  final String text;

  const _CheckItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(LucideIcons.check, size: 16, color: Color(0xFF00BF83)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF151918),
            ),
          ),
        ),
      ],
    );
  }
}
