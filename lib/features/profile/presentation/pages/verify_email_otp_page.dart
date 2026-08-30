import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/routes/app_router.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/widgets/app_status_dialog.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/send_email_verification_otp.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/verify_email_otp.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';

class VerifyEmailOtpPage extends StatefulWidget {
  final String? email;

  const VerifyEmailOtpPage({super.key, this.email});

  static const Color primaryGreen = Color(0xFF00BF83);
  static const Color darkGreen = Color(0xFF008D68);
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color textColor = Color(0xFF0F172A);
  static const Color subtextColor = Color(0xFF475569);

  @override
  State<VerifyEmailOtpPage> createState() => _VerifyEmailOtpPageState();
}

class _VerifyEmailOtpPageState extends State<VerifyEmailOtpPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendCountdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() => _resendCountdown = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _currentOtp {
    return _controllers.map((c) => c.text).join();
  }

  void _onDigitChanged(int index, String value) {
    final cleanValue = value.replaceAll(RegExp(r'\D'), '');
    if (cleanValue.length >= 6) {
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = cleanValue[i];
      }
      _focusNodes[5].unfocus();
      setState(() {});
      return;
    }

    if (value.isNotEmpty) {
      if (value.length > 1) {
        _controllers[index].text = value.substring(value.length - 1);
      }
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    setState(() {});
  }

  void _onDigitBackspace(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
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
        return ProfileBloc(
          getProfile: GetProfile(repository),
          updateProfile: UpdateProfile(repository),
          sendEmailVerificationOtp: SendEmailVerificationOtp(repository),
          verifyEmailOtp: VerifyEmailOtp(repository),
        )..add(SendEmailOtpEvent());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileFailure) {
                AppStatusDialog.show(
                  context: context,
                  title: 'Gagal Verifikasi',
                  message: state.message,
                  type: AppStatusDialogType.error,
                );
              } else if (state is EmailVerificationSuccess) {
                AppStatusDialog.show(
                  context: context,
                  title: 'Berhasil Verifikasi',
                  message: state.message,
                  type: AppStatusDialogType.success,
                );
                context.go(AppRouter.main);
              }
            },
            builder: (context, state) {
              final isLoading = state is ProfileLoading;

              return Column(
                children: [
                  // 1. App Bar Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(
                            LucideIcons.chevronLeft,
                            size: 24,
                            color: VerifyEmailOtpPage.textColor,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Verifikasi Akun',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.roboto(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: VerifyEmailOtpPage.textColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  // 2. Scrollable Body
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 8),

                          // Healthcare Trust Icon Container
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: VerifyEmailOtpPage.primaryGreen.withValues(alpha: 0.1),
                                ),
                              ),
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: VerifyEmailOtpPage.primaryGreen.withValues(alpha: 0.18),
                                ),
                              ),
                              Container(
                                width: 56,
                                height: 56,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: VerifyEmailOtpPage.primaryGreen,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x2900BF83),
                                      blurRadius: 16,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  LucideIcons.shieldCheck,
                                  size: 28,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Title & Subtitle
                          Text(
                            'Verifikasi Email',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: VerifyEmailOtpPage.textColor,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: GoogleFonts.roboto(
                                fontSize: 13.5,
                                color: VerifyEmailOtpPage.subtextColor,
                                height: 1.45,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Masukkan 6-digit kode OTP keamanan yang dikirimkan ke ',
                                ),
                                TextSpan(
                                  text: widget.email != null && widget.email!.isNotEmpty
                                      ? widget.email
                                      : 'email Anda',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: VerifyEmailOtpPage.textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // 6 Individual OTP Digit Input Boxes (Auto-scaled with FittedBox to prevent overflow)
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(6, (index) {
                                final isFocused = _focusNodes[index].hasFocus;
                                final hasValue = _controllers[index].text.isNotEmpty;

                                return Padding(
                                  padding: EdgeInsets.only(right: index == 5 ? 0 : 8),
                                  child: KeyboardListener(
                                    focusNode: FocusNode(),
                                    onKeyEvent: (event) => _onDigitBackspace(index, event),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 150),
                                      width: 46,
                                      height: 58,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isFocused
                                            ? Colors.white
                                            : (hasValue
                                                ? const Color(0xFFE6F8F2)
                                                : const Color(0xFFF8FAFC)),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: isFocused
                                              ? VerifyEmailOtpPage.primaryGreen
                                              : (hasValue
                                                  ? VerifyEmailOtpPage.primaryGreen.withValues(alpha: 0.6)
                                                  : const Color(0xFFCBD5E1)),
                                          width: isFocused ? 2 : 1.5,
                                        ),
                                        boxShadow: isFocused
                                            ? [
                                                BoxShadow(
                                                  color: VerifyEmailOtpPage.primaryGreen.withValues(alpha: 0.25),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ]
                                            : [
                                                const BoxShadow(
                                                  color: Color(0x05000000),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                      ),
                                      child: TextField(
                                        controller: _controllers[index],
                                        focusNode: _focusNodes[index],
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: VerifyEmailOtpPage.textColor,
                                        ),
                                        decoration: const InputDecoration(
                                          counterText: '',
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        onChanged: (val) => _onDigitChanged(index, val),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Countdown & Resend Option
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Tidak menerima kode? ',
                                style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  color: VerifyEmailOtpPage.subtextColor,
                                ),
                              ),
                              if (_resendCountdown > 0)
                                Text(
                                  'Kirim ulang (${_resendCountdown}s)',
                                  style: GoogleFonts.roboto(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                )
                              else
                                GestureDetector(
                                  onTap: isLoading
                                      ? null
                                      : () {
                                          _startCountdown();
                                          context
                                              .read<ProfileBloc>()
                                              .add(SendEmailOtpEvent());
                                        },
                                  child: Text(
                                    'Kirim Ulang OTP',
                                    style: GoogleFonts.roboto(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: VerifyEmailOtpPage.primaryGreen,
                                      decoration: TextDecoration.underline,
                                      decorationColor: VerifyEmailOtpPage.primaryGreen,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 36),

                          // Verify Button
                          if (isLoading)
                            const Center(child: LoadingWidget(message: 'Memverifikasi kode OTP...'))
                          else
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () {
                                  final otp = _currentOtp;
                                  if (otp.length != 6) {
                                    AppStatusDialog.show(
                                      context: context,
                                      title: 'Kode OTP Belum Lengkap',
                                      message: 'Silakan masukkan 6-digit kode OTP dengan lengkap.',
                                      type: AppStatusDialogType.error,
                                    );
                                    return;
                                  }
                                  context.read<ProfileBloc>().add(VerifyEmailOtpEvent(otp));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: VerifyEmailOtpPage.primaryGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 2,
                                  shadowColor: VerifyEmailOtpPage.primaryGreen.withValues(alpha: 0.3),
                                ),
                                child: Text(
                                  'Verifikasi Kode OTP',
                                  style: GoogleFonts.roboto(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 24),

                          // Healthcare Compliance Note
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  LucideIcons.lock,
                                  size: 16,
                                  color: Color(0xFF64748B),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Sesuai Standar Kepatuhan Data Kesehatan UU PDP, kode OTP ini hanya berlaku 10 menit untuk menjaga keamanan data rekam medis Anda.',
                                    style: GoogleFonts.roboto(
                                      fontSize: 11,
                                      height: 1.4,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
