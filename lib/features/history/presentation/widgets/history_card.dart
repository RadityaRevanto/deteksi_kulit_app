import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../domain/entities/history.dart';

class HistoryCard extends StatelessWidget {
  final History history;
  final VoidCallback? onTap;

  const HistoryCard({
    super.key,
    required this.history,
    this.onTap,
  });

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
            child: Row(
              children: [
                // Scan Icon Avatar
                Container(
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
                ),
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
          ),
        ),
      ),
    );
  }
}
