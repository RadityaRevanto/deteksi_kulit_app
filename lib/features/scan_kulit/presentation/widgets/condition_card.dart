import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConditionCard extends StatelessWidget {
  const ConditionCard({super.key});

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
      child: Row(
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
                'Acne / Jerawat',
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
                '87%',
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

    );
  }
}