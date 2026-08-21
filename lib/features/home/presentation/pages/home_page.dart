import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/routes/app_router.dart';
import '../widgets/greeting_section.dart';
import '../widgets/scan_button.dart';
import '../widgets/feature_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color primaryGreen = Color(0xFF00BF83);
  static const Color textColor = Color(0xFF151918);
  static const Color mutedColor = Color(0xFF7B8581);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GreetingSection(
                userName: 'Ahmad',
                onNotificationTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Belum ada notifikasi baru.')),
                  );
                },
              ),
              const SizedBox(height: 24),
              ScanButton(
                onPressed: () {
                  context.push(AppRouter.scanKulit);
                },
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Layanan & Fitur Utama',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FeatureCard(
                      title: 'Konsultasi Dokter',
                      icon: LucideIcons.stethoscope,
                      color: primaryGreen,
                      onTap: () {
                        context.push(AppRouter.konfirmasiDokter);
                      },
                    ),
                  ),
                  Expanded(
                    child: FeatureCard(
                      title: 'Riwayat Analisis',
                      icon: LucideIcons.history,
                      color: const Color(0xFF3B82F6),
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: FeatureCard(
                      title: 'Tips Kulit',
                      icon: LucideIcons.sparkles,
                      color: const Color(0xFFF59E0B),
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: FeatureCard(
                      title: 'Klinik Terdekat',
                      icon: LucideIcons.hospital,
                      color: const Color(0xFFEC4899),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Artikel Rekomendasi',
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 12),
              const _FeaturedTipCard(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedTipCard extends StatelessWidget {
  const _FeaturedTipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF151918), Color(0xFF2D3432)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00BF83).withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Tips Dokter Hari Ini',
                  style: GoogleFonts.roboto(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF00BF83),
                  ),
                ),
              ),
              const Icon(LucideIcons.bookmark, size: 16, color: Colors.white70),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '5 Langkah Mudah Menjaga Kelembapan Kulit Wajah di Cuaca Panas',
            style: GoogleFonts.roboto(
              fontSize: 14,
              height: 1.35,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Gunakan sunscreen dengan SPF minimal 30 dan penuhi asupan cairan tubuh setiap hari.',
            style: GoogleFonts.roboto(
              fontSize: 11,
              height: 1.45,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                '3 menit baca',
                style: GoogleFonts.roboto(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.white54,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    'Baca Selengkapnya',
                    style: GoogleFonts.roboto(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF00BF83),
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(
                    LucideIcons.chevronRight,
                    size: 13,
                    color: Color(0xFF00BF83),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
