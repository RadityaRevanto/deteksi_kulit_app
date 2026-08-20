import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: Color(0xFFE4E4E4), thickness: 1, endIndent: 12),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E2E2)),
          ),
          child: Text(
            'A T A U',
            style: GoogleFonts.roboto(
              color: Color(0xFF9C9CA5),
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.4,
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: Color(0xFFE4E4E4), thickness: 1, indent: 12),
        ),
      ],
    );
  }
}
