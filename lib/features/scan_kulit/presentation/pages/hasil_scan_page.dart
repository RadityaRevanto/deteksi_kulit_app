import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../widgets/condition_card.dart';
import '../widgets/other_probabilities_card.dart';
import '../widgets/ai_summary_card.dart';

class HasilScanPage extends StatelessWidget {
  const HasilScanPage({super.key});

  static const Color primaryGreen = Color(0xFF00BF83);
  static const Color darkGreen = Color(0xFF008D68);
  static const Color lightGreenBg = Color(0xFFE6F8F2);
  static const Color textColor = Color(0xFF151918);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. App Bar / Header Navigation
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      LucideIcons.chevronLeft,
                      size: 24,
                      color: textColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Hasil Analisis AI',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance back button width
                ],
              ),
            ),

            // 2. Scrollable Body Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AI Version Badge
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: lightGreenBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: primaryGreen.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              LucideIcons.sparkles,
                              size: 14,
                              color: darkGreen,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'AI Skin Analysis v2.4',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: darkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card 1: Kemungkinan Kondisi & Keyakinan
                    const ConditionCard(),
                    const SizedBox(height: 16),

                    // Card 2: Probabilitas Masalah Kulit Lain
                    const OtherProbabilitiesCard(),
                    const SizedBox(height: 16),
                    // Card 3: Ringkasan AI & Saran Awal
                    const AiSummaryCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Mengarahkan ke konsultasi dokter...',
                            ),
                            backgroundColor: darkGreen,
                          ),
                        );
                      },
                      icon: const Icon(
                        LucideIcons.stethoscope,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Konfirmasi dengan Dokter',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkGreen,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
