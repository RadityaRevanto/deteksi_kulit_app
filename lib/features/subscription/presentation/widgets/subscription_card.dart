import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/entities/subscription.dart';

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback? onCancel;

  const SubscriptionCard({
    super.key,
    required this.subscription,
    this.onCancel,
  });

  static const Color darkGreen = Color(0xFF008D68);

  Color _getStatusColor() {
    switch (subscription.status.toLowerCase()) {
      case 'active':
        return const Color(0xFF10B981);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'expired':
        return const Color(0xFF64748B);
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return darkGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SkinCek Pro (${subscription.period.toUpperCase()})',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF101828),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  subscription.status.toUpperCase(),
                  style: GoogleFonts.roboto(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatter.format(subscription.amount),
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
              Text(
                'Order: ${subscription.midtransOrderId.substring(0, subscription.midtransOrderId.length > 14 ? 14 : subscription.midtransOrderId.length)}...',
                style: GoogleFonts.roboto(
                  fontSize: 10,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          if (subscription.startsAt != null && subscription.endsAt != null) ...[
            const SizedBox(height: 6),
            Text(
              'Periode: ${subscription.startsAt!.day}/${subscription.startsAt!.month}/${subscription.startsAt!.year} - ${subscription.endsAt!.day}/${subscription.endsAt!.month}/${subscription.endsAt!.year}',
              style: GoogleFonts.roboto(fontSize: 11, color: const Color(0xFF64748B)),
            ),
          ],
          if (subscription.isActive && onCancel != null) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onCancel,
                icon: const Icon(LucideIcons.xCircle, size: 14, color: Color(0xFFEF4444)),
                label: Text(
                  'Batalkan Langganan',
                  style: GoogleFonts.roboto(fontSize: 11, color: const Color(0xFFEF4444), fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
