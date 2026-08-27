import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/routes/app_router.dart';
import '../../../dokter/domain/entities/doctor.dart';
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
                    _ScannedImageCard(imageUrl: scanResult?.imageUrl),
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
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final aiDoctor = Doctor(
                          id: '',
                          name: 'Aura Skin AI',
                          specialist: 'Kecerdasan Buatan',
                          hospital: 'SkinCek AI',
                          rating: 5.0,
                          reviewCount: 100,
                          experienceYears: 10,
                          consultationFee: 0,
                          isOnline: true,
                          avatarUrl: '',
                          isAiBot: true,
                        );
                        final condName = scanResult?.predictedClass ?? 'Acne';
                        final confidence = scanResult != null ? '${(scanResult!.confidence * 100).toStringAsFixed(0)}%' : '87%';
                        final now = DateTime.now();
                        final todayDate = '${now.day}/${now.month}/${now.year}';
                        context.push(
                          AppRouter.chatRoom,
                          extra: {
                            'doctor': aiDoctor,
                            'initialMessage': '[DOKUMEN_HASIL_SCAN]\n📋 Kondisi: $condName\n🎯 Akurasi: $confidence\n📅 Tanggal: $todayDate\n\nMohon saran dan rekomendasi perawatan untuk kondisi kulit seperti ini ya Aura Skin.',
                          },
                        );
                      },
                      icon: const Icon(LucideIcons.bot, size: 18, color: Colors.white),
                      label: Text(
                        'Konsultasikan ke Aura Skin AI',
                        style: GoogleFonts.roboto(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BF83),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.push(AppRouter.konfirmasiDokter);
                      },
                      icon: const Icon(LucideIcons.stethoscope, size: 18, color: darkGreen),
                      label: Text(
                        'Pilih Dokter Spesialis',
                        style: GoogleFonts.roboto(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: darkGreen,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: darkGreen),
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

class _ScannedImageCard extends StatelessWidget {
  final String? imageUrl;

  const _ScannedImageCard({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return const SizedBox.shrink();
    }

    Widget imageWidget;
    final file = File(imageUrl!);

    if (file.existsSync()) {
      imageWidget = Image.file(
        file,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 210,
      );
    } else if (imageUrl!.startsWith('http')) {
      String finalUrl = imageUrl!;
      if (finalUrl.contains('localhost:8000')) {
        finalUrl = finalUrl.replaceAll('localhost:8000', '127.0.0.1:8000');
      }

      imageWidget = Image.network(
        finalUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 210,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else {
      imageWidget = _buildPlaceholder();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAECF0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          imageWidget,
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    LucideIcons.camera,
                    size: 13,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Foto Muka / Kulit Di-scan',
                    style: GoogleFonts.roboto(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 160,
      width: double.infinity,
      color: const Color(0xFFF2F4F7),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Color(0xFF98A2B3),
          size: 36,
        ),
      ),
    );
  }
}