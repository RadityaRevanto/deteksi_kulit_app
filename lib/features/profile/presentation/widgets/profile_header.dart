import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onEditPressed;
  final VoidCallback? onVerifyEmailPressed;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.onEditPressed,
    this.onVerifyEmailPressed,
  });

  static const Color primaryGreen = Color(0xFF00BF83);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAECF0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFF101828),
            backgroundImage: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                ? NetworkImage(profile.avatarUrl!)
                : null,
            child: profile.avatarUrl == null || profile.avatarUrl!.isEmpty
                ? Text(
                    profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'U',
                    style: GoogleFonts.roboto(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: GoogleFonts.roboto(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF101828),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  profile.email,
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    color: const Color(0xFF667085),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: profile.emailVerified ? null : onVerifyEmailPressed,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: profile.emailVerified
                          ? const Color(0xFFE6F8F2)
                          : const Color(0xFFFFFAEB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: profile.emailVerified
                            ? const Color(0xFF00BF83)
                            : const Color(0xFFFEDF89),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          profile.emailVerified
                              ? Icons.check_circle_rounded
                              : Icons.warning_amber_rounded,
                          size: 12,
                          color: profile.emailVerified
                              ? const Color(0xFF008D68)
                              : const Color(0xFFB54708),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          profile.emailVerified
                              ? 'Terverifikasi'
                              : 'Belum Terverifikasi',
                          style: GoogleFonts.roboto(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: profile.emailVerified
                                ? const Color(0xFF008D68)
                                : const Color(0xFFB54708),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onEditPressed,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD0D5DD)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.edit_outlined,
                size: 18,
                color: Color(0xFF344054),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
