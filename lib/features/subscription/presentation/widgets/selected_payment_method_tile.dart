import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'payment_method_option.dart';

class SelectedPaymentMethodTile extends StatelessWidget {
  final PaymentMethodOption method;
  final VoidCallback onChangeTap;

  const SelectedPaymentMethodTile({
    super.key,
    required this.method,
    required this.onChangeTap,
  });

  static const Color primaryGreen = Color(0xFF00BF83);
  static const Color textColor = Color(0xFF101828);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChangeTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                method.icon,
                color: method.iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  if (method.subtitle.isNotEmpty)
                    Text(
                      method.subtitle,
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                ],
              ),
            ),
            Text(
              'Ubah',
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              LucideIcons.chevronRight,
              color: Color(0xFF94A3B8),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
