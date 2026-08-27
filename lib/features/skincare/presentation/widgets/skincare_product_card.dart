import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/entities/skincare_product.dart';

class SkincareProductCard extends StatelessWidget {
  final SkincareProduct product;
  final VoidCallback? onTap;

  const SkincareProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  static const Color primaryGreen = Color(0xFF00BF83);
  static const Color darkGreen = Color(0xFF008D68);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
          children: [
            // Top Badge Header / Image Container
            Container(
              height: 90,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF0FDFA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE6F8F2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.sparkles,
                        color: darkGreen,
                        size: 28,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF00BF83).withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        product.category,
                        style: GoogleFonts.roboto(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: darkGreen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF101828),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (product.keyIngredients.isNotEmpty)
                      Text(
                        'Bahan: ${product.keyIngredients}',
                        style: GoogleFonts.roboto(
                          fontSize: 10,
                          color: const Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const Spacer(),
                    if (product.concern != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          product.concern!.name,
                          style: GoogleFonts.roboto(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF475569),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
