import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showEditNameDialog(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Nama'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Nama Lengkap'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  context.read<ProfileBloc>().add(ProfileUpdated(newName));
                }
                Navigator.pop(dialogContext);
              },
              child: const Text('Simpan'),
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
        final dataSource = ProfileRemoteDataSourceImpl();
        final repository = ProfileRepositoryImpl(remoteDataSource: dataSource);
        final getProfileUseCase = GetProfile(repository);
        final updateProfileUseCase = UpdateProfile(repository);
        return ProfileBloc(
          getProfile: getProfileUseCase,
          updateProfile: updateProfileUseCase,
        )..add(ProfileRequested());
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Profil Saya')),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const LoadingWidget(message: 'Memuat profil...');
            }

            if (state is ProfileFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Terjadi kesalahan: ${state.message}'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(ProfileRequested());
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            if (state is ProfileLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ProfileHeader(profile: state.profile),
                    const SizedBox(height: 24),
                    const Divider(),
                    ProfileMenu(
                      icon: Icons.person_outline,
                      title: 'Edit Profil',
                      onTap: () =>
                          _showEditNameDialog(context, state.profile.name),
                    ),
                    ProfileMenu(
                      icon: Icons.lock_outline,
                      title: 'Pengaturan Keamanan',
                      onTap: () {},
                    ),
                    ProfileMenu(
                      icon: Icons.help_outline,
                      title: 'Bantuan & FAQ',
                      onTap: () {},
                    ),
                    ProfileMenu(
                      icon: Icons.logout,
                      title: 'Keluar',
                      iconColor: Colors.red,
                      onTap: () {},
                    ),
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
