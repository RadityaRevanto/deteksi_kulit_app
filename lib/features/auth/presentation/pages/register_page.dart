import '../../../../core/widgets/app_status_dialog.dart';

import 'package:deteksi_kulit/features/auth/presentation/widgets/auth_divider.dart';
import 'package:deteksi_kulit/features/auth/presentation/widgets/auth_footer_link.dart';
import 'package:deteksi_kulit/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/routes/app_router.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _privacyConsent = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        AppStatusDialog.show(
          context: context,
          title: 'Validasi Gagal',
          message: 'Konfirmasi password tidak sesuai.',
          type: AppStatusDialogType.error,
        );
        return;
      }
      if (!_privacyConsent) {
        AppStatusDialog.show(
          context: context,
          title: 'Persetujuan Privasi',
          message: 'Anda harus menyetujui Kebijakan Privasi untuk mendaftar.',
          type: AppStatusDialogType.error,
        );
        return;
      }

      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          privacyConsent: _privacyConsent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              context.go(AppRouter.login);
            } else if (state is AuthFailure) {
              AppStatusDialog.show(
                context: context,
                title: 'Pendaftaran Gagal',
                message: state.message,
                type: AppStatusDialogType.error,
                buttonText: 'Tutup',
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AuthHeader(),
                    const SizedBox(height: 20),
                    Text(
                      'Buat akun baru ',
                      style: GoogleFonts.roboto(
                        fontSize: 32,
                        height: 1.15,
                        letterSpacing: -1.2,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF171A19),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Daftar untuk mulai mengenali kondisi kulit '
                      'dan mendapatkan analisis berbasis AI.',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        height: 1.6,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7D8581),
                      ),
                    ),
                    const SizedBox(height: 32),
                    AuthTextField(
                      label: 'Nama Lengkap',
                      hintText: 'Masukkan nama lengkap',
                      icon: Icons.person_outline_rounded,
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      label: 'Email',
                      hintText: 'Masukkan email',
                      icon: Icons.mail_outline_rounded,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      label: 'Password',
                      hintText: 'Masukkan password',
                      icon: Icons.lock_outline_rounded,
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: const Color(0xFF9DA0AA),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      label: 'Konfirmasi Password',
                      hintText: 'Masukkan ulang password',
                      icon: Icons.lock_outline_rounded,
                      controller: _confirmPasswordController,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: const Color(0xFF9DA0AA),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _privacyConsent,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (val) {
                            setState(() {
                              _privacyConsent = val ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            'Saya menyetujui Kebijakan Privasi & Syarat Ketentuan',
                            style: GoogleFonts.roboto(
                              fontSize: 13,
                              color: const Color(0xFF5A6360),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    AuthPrimaryButton(
                      text: isLoading ? 'Memproses...' : 'Daftar',
                      onPressed: isLoading ? null : _onRegisterPressed,
                    ),
                    const SizedBox(height: 20),
                    const AuthDivider(),
                    const SizedBox(height: 24),
                    AuthFooterLink(
                      text: 'Sudah punya akun?',
                      actionText: 'Masuk',
                      onTap: () {
                        context.go(AppRouter.login);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
