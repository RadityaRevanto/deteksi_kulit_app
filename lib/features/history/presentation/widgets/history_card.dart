import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/routes/app_router.dart';
import '../../../dokter/domain/entities/doctor.dart';
import '../../domain/entities/history.dart';

class HistoryCard extends StatelessWidget {
  final History history;
  final VoidCallback? onTap;

  const HistoryCard({super.key, required this.history, this.onTap});

  Widget _buildScanAvatar() {
    final url = history.imageUrl;
    if (url != null && url.isNotEmpty) {
      if (url.startsWith('http')) {
        String finalUrl = url;
        if (finalUrl.contains('localhost:8000')) {
          finalUrl = finalUrl.replaceAll('localhost:8000', '127.0.0.1:8000');
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Image.network(
            finalUrl,
            width: 44,
            height: 44,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
          ),
        );
      } else {
        final file = File(url);
        if (file.existsSync()) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.file(
              file,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          );
        }
      }
    }
    return _buildFallbackIcon();
  }

  Widget _buildFallbackIcon() {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: Color(0xFFE6F8F2),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        LucideIcons.scanLine,
        color: Color(0xFF008D68),
        size: 22,
      ),
    );
  }

  void _showConsultTargetSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Konsultasikan Hasil Scan',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF101828),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Kirim hasil scan ${history.conditionName} ke dokter spesialis atau Aura Skin AI Bot.',
                style: GoogleFonts.roboto(fontSize: 12, color: const Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0FDFA),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.bot, color: Color(0xFF008D68)),
                ),
                title: Text('Aura Skin AI Bot', style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text('Tanya AI langsung (Gratis, Respon Instan)', style: GoogleFonts.roboto(fontSize: 12)),
                onTap: () {
                  Navigator.pop(ctx);
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
                  context.push(
                    AppRouter.chatRoom,
                    extra: {
                      'doctor': aiDoctor,
                      'initialMessage': '[DOKUMEN_HASIL_SCAN]\n📋 Kondisi: ${history.conditionName}\n🎯 Akurasi: ${(history.confidence * 100).toStringAsFixed(0)}%\n📅 Tanggal: ${history.date.day}/${history.date.month}/${history.date.year}\n\nMohon saran dan rekomendasi perawatan untuk kondisi kulit seperti ini ya Aura Skin.',
                    },
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE6F8F2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.userCheck, color: Color(0xFF008D68)),
                ),
                title: Text('Dokter Spesialis Kulit', style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text('Pilih dokter spesialis terverifikasi', style: GoogleFonts.roboto(fontSize: 12)),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push(AppRouter.konfirmasiDokter);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final confidencePercent = (history.confidence * 100).toStringAsFixed(0);
    final formattedDate =
        '${history.date.day}/${history.date.month}/${history.date.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Scan User Photo Avatar
                    _buildScanAvatar(),
                    const SizedBox(width: 14),

                    // Condition Title & Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            history.conditionName,
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF151918),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6F8F2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Akurasi $confidencePercent%',
                                  style: GoogleFonts.roboto(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF008D68),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                formattedDate,
                                style: GoogleFonts.roboto(
                                  fontSize: 11,
                                  color: const Color(0xFF7B8581),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Trailing Chevron
                    const Icon(
                      LucideIcons.chevronRight,
                      size: 18,
                      color: Color(0xFF94A3B8),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
