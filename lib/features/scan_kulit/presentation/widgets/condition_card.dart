import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConditionCard extends StatelessWidget {
  final String predictedClass;
  final double confidence;
  final int severityScore;
  final String severityLevel;

  const ConditionCard({
    super.key,
    this.predictedClass = 'Acne / Jerawat',
    this.confidence = 0.87,
    this.severityScore = 0,
    this.severityLevel = 'medium',
  });

  @override
  Widget build(BuildContext context) {
    final confidencePercent = '${(confidence * 100).toInt()}%';

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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left Content: Condition Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kemungkinan Kondisi',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF7B8581),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    predictedClass[0].toUpperCase() + predictedClass.substring(1),
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF151918),
                    ),
                  ),
                ],
              ),

              // Right Content: Confidence Level
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    confidencePercent,
                    style: GoogleFonts.roboto(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF00BF83),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (severityScore > 0) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tingkat Keparahan:',
                  style: GoogleFonts.roboto(fontSize: 13, color: const Color(0xFF7B8581)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: severityLevel.toLowerCase() == 'high'
                        ? Colors.red.withValues(alpha: 0.1)
                        : severityLevel.toLowerCase() == 'medium'
                            ? Colors.orange.withValues(alpha: 0.1)
                            : Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${severityLevel.toUpperCase()} ($severityScore/100)',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: severityLevel.toLowerCase() == 'high'
                          ? Colors.red
                          : severityLevel.toLowerCase() == 'medium'
                              ? Colors.orange
                              : Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}