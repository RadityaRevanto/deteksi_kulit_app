import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/entities/doctor.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onConsultTap;

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onConsultTap,
  });

  @override
  Widget build(BuildContext context) {
    final feeFormatted = 'Rp ${doctor.consultationFee.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with Online indicator
              Stack(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: doctor.isAiBot ? const Color(0xFFF0FDFA) : const Color(0xFFE6F8F2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF00BF83).withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: (doctor.avatarUrl.isNotEmpty && doctor.avatarUrl.startsWith('http'))
                          ? Image.network(
                              doctor.avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                doctor.isAiBot ? LucideIcons.bot : LucideIcons.userCheck,
                                color: const Color(0xFF008D68),
                                size: 26,
                              ),
                            )
                          : Icon(
                              doctor.isAiBot ? LucideIcons.bot : LucideIcons.userCheck,
                              color: const Color(0xFF008D68),
                              size: 26,
                            ),
                    ),
                  ),
                  if (doctor.isOnline)
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              // Doctor details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF151918),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.specialist,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF008D68),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.hospital,
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        color: const Color(0xFF7B8581),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Badges (Rating & Experience)
                    Row(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.star,
                              size: 14,
                              color: Color(0xFFF59E0B),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${doctor.rating}',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF151918),
                              ),
                            ),
                            Text(
                              ' (${doctor.reviewCount})',
                              style: GoogleFonts.roboto(
                                fontSize: 11,
                                color: const Color(0xFF7B8581),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.award,
                              size: 14,
                              color: Color(0xFF64748B),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${doctor.experienceYears} thn exp',
                              style: GoogleFonts.roboto(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Biaya Konsultasi',
                    style: GoogleFonts.roboto(
                      fontSize: 11,
                      color: const Color(0xFF7B8581),
                    ),
                  ),
                  Text(
                    doctor.isAiBot ? 'Gratis (AI Bot)' : feeFormatted,
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: doctor.isAiBot ? const Color(0xFF008D68) : const Color(0xFF151918),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: onConsultTap,
                icon: const Icon(
                  LucideIcons.messageCircle,
                  size: 16,
                  color: Colors.white,
                ),
                label: Text(
                  'Konsultasi',
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BF83),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
