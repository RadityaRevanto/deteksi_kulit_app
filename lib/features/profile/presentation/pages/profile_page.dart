import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
        return ProfileBloc(
          getProfile: getProfileUseCase,
          updateProfile: updateProfileUseCase,
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
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    ProfileHeader(
                      profile: state.profile,
                      onEditPressed: () async {
                        final updated = await context.push<bool>(
                          AppRouter.editProfile,
                          extra: state.profile,
                        );
                        if (updated == true && context.mounted) {
                          context.read<ProfileBloc>().add(ProfileRequested());
                        }
                      },
                    ),
                    const SizedBox(height: 12),
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
                            title: 'Transaksi',
                            onTap: () {},
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
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
