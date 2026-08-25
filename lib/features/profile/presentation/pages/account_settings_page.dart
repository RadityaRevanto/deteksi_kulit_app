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
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/delete_account.dart';
import '../../domain/usecases/export_profile_data.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';
import '../widgets/profile_menu.dart';

class AccountSettingsPage extends StatelessWidget {
  final UserProfile? profile;

  const AccountSettingsPage({super.key, this.profile});

  void _showDeleteAccountConfirmDialog(BuildContext blocContext) {
    showDialog(
      context: blocContext,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Hapus Akun Permanen?',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.red,
            ),
          ),
          content: Text(
            'Tindakan ini akan menghapus akun Anda secara permanen. Anda tidak dapat memulihkan akun ini setelah dihapus.',
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
                blocContext.read<ProfileBloc>().add(ProfileAccountDeleted());
              },
              child: Text(
                'Ya, Hapus Akun',
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
        final deleteAccountUseCase = DeleteAccount(repository);
        final exportDataUseCase = ExportProfileData(repository);
        return ProfileBloc(
          getProfile: getProfileUseCase,
          updateProfile: updateProfileUseCase,
          deleteAccount: deleteAccountUseCase,
          exportProfileData: exportDataUseCase,
        )..add(ProfileRequested());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF101828)),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Pengaturan Akun',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF101828),
            ),
          ),
          centerTitle: false,
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
            } else if (state is ProfileAccountDeletedSuccess) {
              AppStatusDialog.show(
                context: context,
                title: 'Akun Dihapus',
                message: 'Akun Anda berhasil dihapus.',
                type: AppStatusDialogType.info,
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                  context.go(AppRouter.login);
                },
              );
            } else if (state is ProfileDataExportSuccess) {
              AppStatusDialog.show(
                context: context,
                title: 'Ekspor Data Pribadi',
                message: 'File data pribadi siap diunduh (Berlaku ${state.expiresInMinutes} menit).\n\nURL: ${state.downloadUrl}',
                type: AppStatusDialogType.success,
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const LoadingWidget(message: 'Memuat pengaturan akun...');
            }

            final currentProfile = (state is ProfileLoaded) ? state.profile : profile;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFEAECF0)),
                    ),
                    child: Column(
                      children: [
                        ProfileMenu(
                          icon: Icons.person_outline_rounded,
                          title: 'Data Akun',
                          onTap: () async {
                            final updated = await context.push<bool>(
                              AppRouter.editProfile,
                              extra: currentProfile,
                            );
                            if (updated == true && context.mounted) {
                              context.read<ProfileBloc>().add(ProfileRequested());
                            }
                          },
                        ),
                        const Divider(height: 1, color: Color(0xFFF2F4F7)),
                        ProfileMenu(
                          icon: Icons.download_rounded,
                          title: 'Unduh Data Pribadi (UU PDP)',
                          onTap: () {
                            context.read<ProfileBloc>().add(ProfileDataExportRequested());
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFEAECF0)),
                    ),
                    child: ProfileMenu(
                      icon: Icons.delete_forever_rounded,
                      title: 'Hapus Akun Permanen',
                      iconColor: Colors.red,
                      textColor: Colors.red,
                      onTap: () => _showDeleteAccountConfirmDialog(context),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
