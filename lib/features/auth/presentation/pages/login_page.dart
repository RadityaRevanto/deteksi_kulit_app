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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
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
              AppStatusDialog.show(
                context: context,
                title: 'Login Berhasil',
                message: 'Selamat Datang, ${state.user.name}!',
                type: AppStatusDialogType.success,
                buttonText: 'Lanjutkan',
                barrierDismissible: false,
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go(AppRouter.main);
                },
              );
            } else if (state is AuthFailure) {
              AppStatusDialog.show(
                context: context,
                title: 'Gagal Masuk',
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
                      'Selamat datang\nkembali 👋',
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
                      'Masuk untuk melanjutkan perjalanan menuju '
                      'kulit yang lebih sehat.',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        height: 1.6,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7D8581),
                      ),
                    ),
                    const SizedBox(height: 32),
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Lupa Kata Sandi?'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    AuthPrimaryButton(
                      text: isLoading ? 'Memproses...' : 'Masuk',
                      onPressed: isLoading ? null : _onLoginPressed,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 20),
                    const AuthDivider(),
                    const SizedBox(height: 24),
                    AuthFooterLink(
                      text: 'Belum punya akun?',
                      actionText: 'Buat akun',
                      onTap: () {
                        context.go(AppRouter.register);
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
