import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthFooterLink extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onTap;

  const AuthFooterLink({
    super.key,
    required this.text,
    required this.actionText,
    required this.onTap,
  });

  static const Color darkGreen = Color(0xFF008D68);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(
            '$text ',
            style: GoogleFonts.roboto(
              fontSize: 13,
              height: 1.6,
              color: Color(0xFF777777),
              fontWeight: FontWeight.w400,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              actionText,
              style: GoogleFonts.roboto(
                fontSize: 13,
                height: 1.6,
                color: darkGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
