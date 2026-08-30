import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PriceSummaryBreakdown extends StatelessWidget {
  final int planAmount;
  final String ppnText;

  const PriceSummaryBreakdown({
    super.key,
    this.planAmount = 15000,
    this.ppnText = 'Gratis',
  });

  static const Color textColor = Color(0xFF101828);
  static const Color orangeColor = Color(0xFFF97316);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Harga Paket Pro',
              style: GoogleFonts.roboto(
                fontSize: 13.5,
                color: const Color(0xFF64748B),
              ),
            ),
            Text(
              'Rp${planAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
              style: GoogleFonts.roboto(fontSize: 13.5, color: textColor),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PPN',
              style: GoogleFonts.roboto(
                fontSize: 13.5,
                color: const Color(0xFF64748B),
              ),
            ),
            Text(
              ppnText,
              style: GoogleFonts.roboto(
                fontSize: 13.5,
                color: orangeColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Biaya',
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              'Rp${planAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: orangeColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
