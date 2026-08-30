import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PaymentMethodOption {
  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final String category;
  final String snapAnchor;

  const PaymentMethodOption({
    required this.id,
    required this.name,
    this.subtitle = '',
    required this.icon,
    required this.iconColor,
    required this.category,
    required this.snapAnchor,
  });

  static const List<PaymentMethodOption> allOptions = [
    // E-Wallet
    PaymentMethodOption(
      id: 'qris',
      name: 'QRIS',
      subtitle: '',
      icon: LucideIcons.qrCode,
      iconColor: Color(0xFF0F172A),
      category: 'E-Wallet',
      snapAnchor: '#/gopay',
    ),
    PaymentMethodOption(
      id: 'shopeepay',
      name: 'ShopeePay / SPayLater',
      subtitle: '',
      icon: LucideIcons.shoppingBag,
      iconColor: Color(0xFFEE4D2D),
      category: 'E-Wallet',
      snapAnchor: '#/shopeepay',
    ),
    PaymentMethodOption(
      id: 'gopay',
      name: 'GoPay / GoPay Later',
      subtitle: '',
      icon: LucideIcons.wallet,
      iconColor: Color(0xFF00AED6),
      category: 'E-Wallet',
      snapAnchor: '#/gopay',
    ),
    PaymentMethodOption(
      id: 'ovo',
      name: 'OVO',
      subtitle: 'via QRIS',
      icon: LucideIcons.circleDot,
      iconColor: Color(0xFF4C3494),
      category: 'E-Wallet',
      snapAnchor: '#/gopay',
    ),
    PaymentMethodOption(
      id: 'dana',
      name: 'Dana',
      subtitle: 'via QRIS',
      icon: LucideIcons.badgeCheck,
      iconColor: Color(0xFF108EE9),
      category: 'E-Wallet',
      snapAnchor: '#/gopay',
    ),

    // Transfer Virtual Account
    PaymentMethodOption(
      id: 'bca',
      name: 'BCA Virtual Account',
      subtitle: '',
      icon: LucideIcons.building2,
      iconColor: Color(0xFF005DA6),
      category: 'Transfer Virtual Account',
      snapAnchor: '#/bank-transfer/bca-va',
    ),
    PaymentMethodOption(
      id: 'mandiri',
      name: 'Mandiri Bill / VA',
      subtitle: '',
      icon: LucideIcons.landmark,
      iconColor: Color(0xFF003D79),
      category: 'Transfer Virtual Account',
      snapAnchor: '#/bank-transfer/mandiri-va',
    ),
    PaymentMethodOption(
      id: 'bni',
      name: 'BNI Virtual Account',
      subtitle: '',
      icon: LucideIcons.building,
      iconColor: Color(0xFFF15A24),
      category: 'Transfer Virtual Account',
      snapAnchor: '#/bank-transfer/bni-va',
    ),
    PaymentMethodOption(
      id: 'bri',
      name: 'BRI Virtual Account',
      subtitle: '',
      icon: LucideIcons.home,
      iconColor: Color(0xFF00529C),
      category: 'Transfer Virtual Account',
      snapAnchor: '#/bank-transfer/bri-va',
    ),
    PaymentMethodOption(
      id: 'permata',
      name: 'Permata Virtual Account',
      subtitle: '',
      icon: LucideIcons.creditCard,
      iconColor: Color(0xFF00875A),
      category: 'Transfer Virtual Account',
      snapAnchor: '#/bank-transfer/permata-va',
    ),
  ];
}
