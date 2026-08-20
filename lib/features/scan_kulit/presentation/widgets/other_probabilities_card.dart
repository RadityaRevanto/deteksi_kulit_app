import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Item data model untuk probabilitas masalah kulit
class SkinIssueProbability {
  final String title;
  final double percentage; // e.g. 0.05 for 5%

  const SkinIssueProbability({
    required this.title,
    required this.percentage,
  });
}

/// Kartu Probabilitas Masalah Kulit Lain
class OtherProbabilitiesCard extends StatelessWidget {
  final List<SkinIssueProbability> issues;

  const OtherProbabilitiesCard({
    super.key,
    this.issues = const [
      SkinIssueProbability(title: 'Dark Spot', percentage: 0.05),
      SkinIssueProbability(title: 'Pigmentasi', percentage: 0.03),
      SkinIssueProbability(title: 'Blackhead / Komedo', percentage: 0.02),
    ],
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
          Text(
            'Probabilitas Masalah Kulit Lain',
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF151918),
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: issues.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = issues[index];
              final percentText = '${(item.percentage * 100).toInt()}%';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2D3432),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F8FA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          percentText,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF00BF83),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: item.percentage,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFF0F0F0),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF00BF83),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
