import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/routes/app_router.dart';
import '../widgets/condition_card.dart';
import '../widgets/other_probabilities_card.dart';
import '../widgets/ai_summary_card.dart';

import '../../domain/entities/scan_result.dart';

class HasilScanPage extends StatelessWidget {
  final ScanResult? scanResult;

  const HasilScanPage({super.key, this.scanResult});

  static const Color primaryGreen = Color(0xFF00BF83);
  static const Color darkGreen = Color(0xFF008D68);
  static const Color lightGreenBg = Color(0xFFE6F8F2);
  static const Color textColor = Color(0xFF151918);

  @override
  Widget build(BuildContext context) {
    final otherIssues = <SkinIssueProbability>[];
    if (scanResult?.probabilities != null) {
      scanResult!.probabilities.forEach((key, val) {
        if (key.toLowerCase() != scanResult!.predictedClass.toLowerCase()) {
          otherIssues.add(SkinIssueProbability(
            title: key[0].toUpperCase() + key.substring(1),
            percentage: val,
          ));
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
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
                      textAlign: TextAlign.start,
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConditionCard(
                      predictedClass: scanResult?.predictedClass ?? 'Acne / Jerawat',
                      confidence: scanResult?.confidence ?? 0.87,
                      severityScore: scanResult?.severityScore ?? 42,
                      severityLevel: scanResult?.severityLevel ?? 'medium',
                    ),
                    const SizedBox(height: 16),
                    OtherProbabilitiesCard(
                      issues: otherIssues.isNotEmpty
                          ? otherIssues
                          : const [
                              SkinIssueProbability(title: 'Dark Spot', percentage: 0.05),
                              SkinIssueProbability(title: 'Pigmentasi', percentage: 0.03),
                              SkinIssueProbability(title: 'Blackhead / Komedo', percentage: 0.02),
                            ],
                    ),
                    const SizedBox(height: 16),
                   
                    AiSummaryCard(
                      disclaimer: scanResult?.disclaimer,
                      notice: scanResult?.notice,
                    ),
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
                        context.push(AppRouter.konfirmasiDokter);
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