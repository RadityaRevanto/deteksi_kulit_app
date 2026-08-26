import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/widgets/app_status_dialog.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/delete_avatar.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';

import '../widgets/labeled_text_field.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfile? profile;

  const EditProfilePage({super.key, this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  String _selectedGender = 'laki_laki';

  File? _avatarFile;
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  static const Color primaryButtonColor = Color(0xFFFF6B00);

  @override
  void initState() {
    super.initState();
    final profile = widget.profile;
    final nameParts = (profile?.name ?? '').split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    _firstNameController = TextEditingController(text: firstName);
    _lastNameController = TextEditingController(text: lastName);
    _emailController = TextEditingController(text: profile?.email ?? '');
    _phoneController = TextEditingController(text: '+62 82328277993');
    _dobController = TextEditingController(
      text: _formatDobForDisplay(profile?.dateOfBirth),
    );
    final g = profile?.gender?.toLowerCase() ?? '';
    if (g == 'perempuan' || g == 'female' || g == 'p') {
      _selectedGender = 'perempuan';
    } else {
      _selectedGender = 'laki_laki';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _avatarFile = File(picked.path);
      });
    }
  }

  Future<void> _selectDateOfBirth() async {
    DateTime initialDate = DateTime.now();
    try {
      if (_dobController.text.contains('/')) {
        initialDate = DateFormat('dd/MM/yyyy').parse(_dobController.text);
      } else if (_dobController.text.contains('-')) {
        initialDate = DateTime.parse(_dobController.text);
      }
    } catch (_) {}

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  String _formatDobForDisplay(String? rawDob) {
    if (rawDob == null || rawDob.trim().isEmpty) return '';
    try {
      if (rawDob.contains('-')) {
        final parsed = DateTime.parse(rawDob.trim());
        return DateFormat('dd/MM/yyyy').format(parsed);
      }
    } catch (_) {}
    return rawDob;
  }

  void _onSavePressed(BuildContext blocContext) {
    if (_formKey.currentState?.validate() ?? false) {
      final fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'.trim();
      
      String? formattedDob;
      if (_dobController.text.trim().isNotEmpty) {
        try {
          if (_dobController.text.contains('/')) {
            final parsed = DateFormat('dd/MM/yyyy').parse(_dobController.text.trim());
            formattedDob = DateFormat('yyyy-MM-dd').format(parsed);
          } else {
            final parsed = DateTime.parse(_dobController.text.trim());
            formattedDob = DateFormat('yyyy-MM-dd').format(parsed);
          }
        } catch (_) {
          formattedDob = _dobController.text.trim();
        }
      }

      setState(() {
        _isSubmitting = true;
      });

      blocContext.read<ProfileBloc>().add(
            ProfileUpdated(
              name: fullName,
              gender: _selectedGender,
              dateOfBirth: formattedDob,
            ),
          );
    }
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
        final deleteAvatarUseCase = DeleteAvatar(repository);
        return ProfileBloc(
          getProfile: getProfileUseCase,
          updateProfile: updateProfileUseCase,
          deleteAvatar: deleteAvatarUseCase,
        )..add(ProfileRequested());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Data Akun',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              if (_isSubmitting) {
                setState(() {
                  _isSubmitting = false;
                });
                AppStatusDialog.show(
                  context: context,
                  title: 'Berhasil',
                  message: 'Data akun berhasil diperbarui',
                  type: AppStatusDialogType.success,
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.pop(true);
                  },
                );
              } else {
                final nameParts = state.profile.name.split(' ');
                if (_firstNameController.text.isEmpty) {
                  _firstNameController.text = nameParts.isNotEmpty ? nameParts.first : '';
                  _lastNameController.text = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
                }
                if (_emailController.text.isEmpty) {
                  _emailController.text = state.profile.email;
                }
                if (state.profile.dateOfBirth != null && state.profile.dateOfBirth!.isNotEmpty) {
                  _dobController.text = _formatDobForDisplay(state.profile.dateOfBirth);
                }
              }
            } else if (state is ProfileFailure) {
              setState(() {
                _isSubmitting = false;
              });
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
              return const LoadingWidget(message: 'Menyimpan data profil...');
            }

            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Center(
                              child: GestureDetector(
                                onTap: _pickAvatar,
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 46,
                                      backgroundColor: const Color(0xFF101828),
                                      backgroundImage: _avatarFile != null
                                          ? FileImage(_avatarFile!) as ImageProvider
                                          : (widget.profile?.avatarUrl != null &&
                                                  widget.profile!.avatarUrl!.isNotEmpty)
                                              ? NetworkImage(widget.profile!.avatarUrl!)
                                              : null,
                                      child: _avatarFile == null &&
                                              (widget.profile?.avatarUrl == null ||
                                                  widget.profile!.avatarUrl!.isEmpty)
                                          ? Text(
                                              _firstNameController.text.isNotEmpty
                                                  ? _firstNameController.text[0].toUpperCase()
                                                  : 'U',
                                              style: GoogleFonts.roboto(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '"Sentuh untuk mengganti Foto Profile"',
                                      style: GoogleFonts.roboto(
                                        fontSize: 13,
                                        color: const Color(0xFF667085),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            LabeledTextField(
                              label: 'Nama Depan',
                              isRequired: true,
                              controller: _firstNameController,
                              hintText: 'Masukkan nama depan',
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Nama depan wajib diisi';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            LabeledTextField(
                              label: 'Nama Belakang',
                              controller: _lastNameController,
                              hintText: 'Masukkan nama belakang',
                            ),
                            const SizedBox(height: 18),
                            LabeledTextField(
                              label: 'Email',
                              isRequired: true,
                              controller: _emailController,
                              hintText: 'Masukkan email',
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Email wajib diisi';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            LabeledTextField(
                              label: 'Nomor Handphone',
                              isRequired: true,
                              controller: _phoneController,
                              hintText: '+62',
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 18),
                            LabeledTextField(
                              label: 'Tanggal Lahir',
                              isRequired: true,
                              controller: _dobController,
                              hintText: 'DD/MM/YYYY',
                              readOnly: true,
                              onTap: _selectDateOfBirth,
                              suffixIcon: const Icon(
                                Icons.calendar_month_outlined,
                                color: Color(0xFF667085),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Jenis Kelamin',
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF344054),
                                      ),
                                    ),
                                    Text(
                                      ' *',
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => setState(() => _selectedGender = 'laki_laki'),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          decoration: BoxDecoration(
                                            color: _selectedGender == 'laki_laki' ? const Color(0xFFE6F8F2) : Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: _selectedGender == 'laki_laki' ? const Color(0xFF00BF83) : const Color(0xFFD0D5DD),
                                              width: _selectedGender == 'laki_laki' ? 2 : 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.male_rounded,
                                                color: _selectedGender == 'laki_laki' ? const Color(0xFF00BF83) : const Color(0xFF667085),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                'Laki-laki',
                                                style: GoogleFonts.roboto(
                                                  fontWeight: _selectedGender == 'laki_laki' ? FontWeight.bold : FontWeight.normal,
                                                  color: _selectedGender == 'laki_laki' ? const Color(0xFF00BF83) : const Color(0xFF344054),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => setState(() => _selectedGender = 'perempuan'),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          decoration: BoxDecoration(
                                            color: _selectedGender == 'perempuan' ? const Color(0xFFE6F8F2) : Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: _selectedGender == 'perempuan' ? const Color(0xFF00BF83) : const Color(0xFFD0D5DD),
                                              width: _selectedGender == 'perempuan' ? 2 : 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.female_rounded,
                                                color: _selectedGender == 'perempuan' ? const Color(0xFF00BF83) : const Color(0xFF667085),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                'Perempuan',
                                                style: GoogleFonts.roboto(
                                                  fontWeight: _selectedGender == 'perempuan' ? FontWeight.bold : FontWeight.normal,
                                                  color: _selectedGender == 'perempuan' ? const Color(0xFF00BF83) : const Color(0xFF344054),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Color(0xFFF2F4F7)),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryButtonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => _onSavePressed(context),
                        child: Text(
                          'Simpan Perubahan',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
