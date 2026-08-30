import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/routes/app_router.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/widgets/app_status_dialog.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth/auth_event.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu.dart';
import '../widgets/profile_stats_card.dart';

import '../../domain/usecases/send_email_verification_otp.dart';
import '../../domain/usecases/verify_email_otp.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Color primaryGreen = Color(0xFF00BF83);

  void _showLogoutConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Konfirmasi Keluar',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin keluar dari akun ini?',
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: const Color(0xFF5A6360),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Batal',
                style: GoogleFonts.roboto(color: const Color(0xFF5A6360)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<AuthBloc>().add(AuthLogoutRequested());
                context.go(AppRouter.login);
              },
              child: Text(
                'Keluar',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final dataSource = ProfileRemoteDataSourceImpl(
          apiClient: context.read<ApiClient>(),
        );
        final repository = ProfileRepositoryImpl(remoteDataSource: dataSource);
        final getProfileUseCase = GetProfile(repository);
        final updateProfileUseCase = UpdateProfile(repository);
        final sendEmailOtpUseCase = SendEmailVerificationOtp(repository);
        final verifyEmailOtpUseCase = VerifyEmailOtp(repository);
        return ProfileBloc(
          getProfile: getProfileUseCase,
          updateProfile: updateProfileUseCase,
          sendEmailVerificationOtp: sendEmailOtpUseCase,
          verifyEmailOtp: verifyEmailOtpUseCase,
        )..add(ProfileRequested());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            'Profile',
            style: GoogleFonts.roboto(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF101828),
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Color(0xFF344054),
                size: 24,
              ),
            ),
            Stack(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Color(0xFF344054),
                    size: 26,
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileFailure) {
              AppStatusDialog.show(
                context: context,
                title: 'Gagal',
                message: state.message,
                type: AppStatusDialogType.error,
              );
            } else if (state is EmailOtpSentSuccess) {
              AppStatusDialog.show(
                context: context,
                title: 'OTP Terkirim',
                message: state.message,
                type: AppStatusDialogType.success,
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const LoadingWidget(message: 'Memuat profil...');
            }
            if (state is ProfileFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Gagal memuat profil: ${state.message}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(color: const Color(0xFF5A6360)),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                        ),
                        onPressed: () {
                          context.read<ProfileBloc>().add(ProfileRequested());
                        },
                        child: Text(
                          'Coba Lagi',
                          style: GoogleFonts.roboto(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is ProfileLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProfileBloc>().add(ProfileRequested());
                },
                color: primaryGreen,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      ProfileHeader(
                        profile: state.profile,
                        onVerifyEmailPressed: () async {
                          await context.push(
                            AppRouter.verifyEmailOtp,
                            extra: state.profile.email,
                          );
                          if (context.mounted) {
                            context.read<ProfileBloc>().add(ProfileRequested());
                          }
                        },
                        onEditPressed: () async {
                          await context.push(
                            AppRouter.editProfile,
                            extra: state.profile,
                          );
                          if (context.mounted) {
                            context.read<ProfileBloc>().add(ProfileRequested());
                          }
                        },
                      ),
                    if (!state.profile.emailVerified) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFAEB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFEDF89)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              size: 22,
                              color: Color(0xFFB54708),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Verifikasi Email Diperlukan',
                                    style: GoogleFonts.roboto(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFB54708),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Verifikasi email Anda terlebih dahulu untuk menggunakan fitur Scan Kulit & Chat Dokter.',
                                    style: GoogleFonts.roboto(
                                      fontSize: 11,
                                      color: const Color(0xFFB54708),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                final verified = await context.push<bool>(
                                  AppRouter.verifyEmailOtp,
                                  extra: state.profile.email,
                                );
                                if (verified == true && context.mounted) {
                                  context.read<ProfileBloc>().add(ProfileRequested());
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFB54708),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Kirim OTP',
                                style: GoogleFonts.roboto(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF008D68), Color(0xFF00BF83)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A00BF83),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.crown, color: Colors.white, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Upgrade ke SkinCek Pro ✨',
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Scan & Chat Dokter tanpa batas kuota',
                                  style: GoogleFonts.roboto(
                                    fontSize: 11,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.push(AppRouter.subscriptionPlan);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              elevation: 0,
                            ),
                            child: Text(
                              'Langganan',
                              style: GoogleFonts.roboto(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF008D68),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ProfileStatsCard(profile: state.profile),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFEAECF0)),
                      ),
                      child: Column(
                        children: [
                          ProfileMenu(
                            icon: Icons.receipt_long_outlined,
                            title: 'Riwayat Langganan Pro',
                            onTap: () {
                              context.push(AppRouter.subscriptionHistory);
                            },
                          ),
                          const Divider(height: 1, color: Color(0xFFF2F4F7)),
                          ProfileMenu(
                            icon: Icons.calendar_today_outlined,
                            title: 'Treatment Booking',
                            onTap: () {},
                          ),
                          const Divider(height: 1, color: Color(0xFFF2F4F7)),
                          ProfileMenu(
                            icon: Icons.star_outline_rounded,
                            title: 'Ulasan',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFEAECF0)),
                      ),
                      child: Column(
                        children: [
                          ProfileMenu(
                            icon: Icons.settings_outlined,
                            title: 'Pengaturan Akun',
                            onTap: () async {
                              await context.push(
                                AppRouter.accountSettings,
                                extra: state.profile,
                              );
                              if (context.mounted) {
                                context.read<ProfileBloc>().add(ProfileRequested());
                              }
                            },
                          ),
                          const Divider(height: 1, color: Color(0xFFF2F4F7)),
                          ProfileMenu(
                            icon: Icons.location_on_outlined,
                            title: 'Pengaturan Alamat',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFEAECF0)),
                      ),
                      child: Column(
                        children: [
                          ProfileMenu(
                            icon: Icons.help_outline_rounded,
                            title: 'Pusat Bantuan',
                            onTap: () {},
                          ),
                          const Divider(height: 1, color: Color(0xFFF2F4F7)),
                          ProfileMenu(
                            icon: Icons.logout_rounded,
                            title: 'Keluar',
                            iconColor: Colors.red,
                            textColor: Colors.red,
                            onTap: () => _showLogoutConfirmDialog(context),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
