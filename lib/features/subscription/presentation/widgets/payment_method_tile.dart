import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'payment_method_option.dart';

class PaymentMethodTile extends StatelessWidget {
  final PaymentMethodOption method;
  final bool isSelected;
  final ValueChanged<PaymentMethodOption> onSelect;

  const PaymentMethodTile({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onSelect,
  });

  static const Color primaryGreen = Color(0xFF00BF83);
  static const Color darkGreen = Color(0xFF008D68);
  static const Color textColor = Color(0xFF101828);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? primaryGreen : const Color(0xFFE2E8F0),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(method.icon, color: method.iconColor, size: 22),
        ),
        title: Row(
          children: [
            Text(
              method.name,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: textColor,
              ),
            ),
            if (method.subtitle.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(
                method.subtitle,
                style: GoogleFonts.roboto(
                  fontSize: 11,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ],
        ),
        trailing: isSelected
            ? const Icon(LucideIcons.checkCircle2, color: darkGreen, size: 20)
            : const Icon(LucideIcons.circle, color: Color(0xFFCBD5E1), size: 20),
        onTap: () => onSelect(method),
      ),
    );
  }
}

class PaymentMethodPickerList extends StatelessWidget {
  final PaymentMethodOption selectedMethod;
  final ValueChanged<PaymentMethodOption> onSelectMethod;

  const PaymentMethodPickerList({
    super.key,
    required this.selectedMethod,
    required this.onSelectMethod,
  });

  @override
  Widget build(BuildContext context) {
    final eWalletMethods =
        PaymentMethodOption.allOptions.where((m) => m.category == 'E-Wallet').toList();
    final vaMethods = PaymentMethodOption.allOptions
        .where((m) => m.category == 'Transfer Virtual Account')
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'E-Wallet',
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 10),
          ...eWalletMethods.map((m) => PaymentMethodTile(
                method: m,
                isSelected: selectedMethod.id == m.id,
                onSelect: onSelectMethod,
              )),
          const SizedBox(height: 24),
          Text(
            'Transfer Virtual Account',
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 10),
          ...vaMethods.map((m) => PaymentMethodTile(
                method: m,
                isSelected: selectedMethod.id == m.id,
                onSelect: onSelectMethod,
              )),
        ],
      ),
    );
  }
}
