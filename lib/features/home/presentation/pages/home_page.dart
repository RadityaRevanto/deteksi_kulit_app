import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/routes/app_router.dart';
import '../../../skincare/domain/entities/skincare_product.dart';
import '../widgets/greeting_section.dart';
import '../widgets/scan_button.dart';
import '../widgets/feature_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color primaryGreen = Color(0xFF00BF83);
  static const Color textColor = Color(0xFF151918);

  static const List<SkincareProduct> recommendedProducts = [
    SkincareProduct(
      uuid: 'p1',
      name: 'CeraVe Hydrating Cleanser',
      category: 'Pembersih Wajah',
      gender: 'Unisex',
      keyIngredients: 'Ceramides & Hyaluronic Acid',
      usageInstruction: 'Gunakan pagi dan malam hari pada wajah yang basah.',
      isActive: true,
    ),
    SkincareProduct(
      uuid: 'p2',
      name: 'Somethinc Niacinamide Serum',
      category: 'Serum Wajah',
      gender: 'Unisex',
      keyIngredients: 'Niacinamide 10% & Centella',
      usageInstruction: 'Teteskan 3-5 tetes secara merata pada kulit wajah.',
      isActive: true,
    ),
    SkincareProduct(
      uuid: 'p3',
      name: 'Anessa Perfect UV Sunscreen',
      category: 'Tabir Surya',
      gender: 'Unisex',
      keyIngredients: 'Zinc Oxide & Hyaluronic Acid',
      usageInstruction: 'Oleskan 15 menit sebelum terpapar sinar matahari.',
      isActive: true,
    ),
  ];

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
                      title: 'Produk Skincare',
                      icon: LucideIcons.shoppingBag,
                      color: const Color(0xFF8B5CF6),
                      onTap: () {
                        context.push(AppRouter.skincareCatalog);
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
                      title: 'Langganan Pro',
                      icon: LucideIcons.crown,
                      color: const Color(0xFFF59E0B),
                      onTap: () {
                        context.push(AppRouter.subscriptionPlan);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Rekomendasi Skincare Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rekomendasi Skincare',
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      letterSpacing: -0.2,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push(AppRouter.skincareCatalog);
                    },
                    child: Row(
                      children: [
                        Text(
                          'Lihat Semua',
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primaryGreen,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          LucideIcons.chevronRight,
                          size: 14,
                          color: primaryGreen,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Recommended Skincare Horizontal Product Cards List
              SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendedProducts.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final product = recommendedProducts[index];
                    return _HomeProductCard(
                      product: product,
                      onTap: () {
                        context.push(
                          AppRouter.skincareDetail,
                          extra: product,
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeProductCard extends StatelessWidget {
  final SkincareProduct product;
  final VoidCallback onTap;

  const _HomeProductCard({
    required this.product,
    required this.onTap,
  });

  static const Color primaryGreen = Color(0xFF00BF83);
  static const Color textColor = Color(0xFF151918);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F8F2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        LucideIcons.sparkles,
                        color: primaryGreen,
                        size: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.category,
                        style: GoogleFonts.roboto(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.keyIngredients,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                    fontSize: 10.5,
                    color: const Color(0xFF64748B),
                    height: 1.2,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Lihat Detail',
                  style: GoogleFonts.roboto(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  LucideIcons.chevronRight,
                  size: 12,
                  color: primaryGreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
