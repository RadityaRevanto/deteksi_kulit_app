import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/routes/app_router.dart';
import '../../domain/entities/skincare_product.dart';

class SkincareDetailPage extends StatelessWidget {
  final SkincareProduct product;

  const SkincareDetailPage({super.key, required this.product});

  static const Color primaryGreen = Color(0xFF00BF83);
  static const Color darkGreen = Color(0xFF008D68);
  static const Color textColor = Color(0xFF101828);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(LucideIcons.chevronLeft, color: textColor),
        ),
        title: Text(
          'Detail Produk Skincare',
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Product Header Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x06000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE6F8F2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.sparkles,
                      color: darkGreen,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    product.name,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDFA),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: primaryGreen.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          product.category,
                          style: GoogleFonts.roboto(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),
                      ),
                      if (product.concern != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            product.concern!.name,
                            style: GoogleFonts.roboto(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Key Ingredients Section
            _buildSectionCard(
              icon: LucideIcons.flaskConical,
              title: 'Bahan Utama (Key Ingredients)',
              content: product.keyIngredients.isNotEmpty ? product.keyIngredients : 'Tidak ada bahan khusus tercantum.',
            ),
            const SizedBox(height: 12),

            // Usage Instruction Section
            _buildSectionCard(
              icon: LucideIcons.checkCircle2,
              title: 'Instruksi Penggunaan',
              content: product.usageInstruction.isNotEmpty ? product.usageInstruction : 'Gunakan sesuai petunjuk atau panduan dokter.',
            ),
            const SizedBox(height: 12),

            // Warning Section if available
            if (product.warning != null && product.warning!.isNotEmpty) ...[
              _buildSectionCard(
                icon: LucideIcons.alertTriangle,
                title: 'Peringatan & Kontraindikasi',
                content: product.warning!,
                isWarning: true,
              ),
              const SizedBox(height: 12),
            ],

            // Doctor Developer / Recommender Section
            if (product.doctor != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF00BF83).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.stethoscope, color: darkGreen, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Merekomendasikan Dokter:',
                            style: GoogleFonts.roboto(fontSize: 11, color: const Color(0xFF64748B)),
                          ),
                          Text(
                            product.doctor!.name,
                            style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.push(
                          AppRouter.chatRoom,
                          extra: {'doctor': product.doctor},
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: Text('Chat Dokter', style: GoogleFonts.roboto(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required String content,
    bool isWarning = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isWarning ? const Color(0xFFFFF1F2) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isWarning ? const Color(0xFFFECDD3) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: isWarning ? const Color(0xFFE11D48) : darkGreen),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isWarning ? const Color(0xFF9F1239) : textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.roboto(
              fontSize: 12.5,
              height: 1.45,
              color: isWarning ? const Color(0xFF881337) : const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}
