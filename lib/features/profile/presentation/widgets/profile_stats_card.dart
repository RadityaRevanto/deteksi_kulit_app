import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/user_profile.dart';

class ProfileStatsCard extends StatelessWidget {
  final UserProfile profile;

  const ProfileStatsCard({super.key, required this.profile});

  static const Color primaryGreen = Color(0xFF00BF83);

  @override
  Widget build(BuildContext context) {
    final isPro = profile.subscriptionStatus.toLowerCase() == 'pro';
    final roleText = profile.role[0].toUpperCase() + profile.role.substring(1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAECF0)),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Role & Status',
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF101828),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPro ? const Color(0xFFFFFAEB) : const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isPro ? const Color(0xFFFEDF89) : const Color(0xFFD0D5DD),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Paket ${profile.subscriptionStatus}',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isPro ? const Color(0xFFB54708) : const Color(0xFF475467),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF2F4F7)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  label: 'Role Akun',
                  value: roleText,
                  color: const Color(0xFF0284C7),
                ),
              ),
              Container(height: 36, width: 1, color: const Color(0xFFF2F4F7)),
              Expanded(
                child: _buildStatItem(
                  label: 'Total Scan',
                  value: '${profile.scanCount}',
                  color: primaryGreen,
                ),
              ),
              Container(height: 36, width: 1, color: const Color(0xFFF2F4F7)),
              Expanded(
                child: _buildStatItem(
                  label: 'Sisa Chat',
                  value: '${profile.remainingFreeMessages}',
                  color: const Color(0xFFFF6B00),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF101828),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 11,
            color: const Color(0xFF667085),
          ),
        ),
      ],
    );
  }
}
