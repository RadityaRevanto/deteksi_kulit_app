import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/routes/app_router.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/widgets/app_status_dialog.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../data/datasources/scan_remote_data_source.dart';
import '../../data/repositories/scan_repository_impl.dart';
import '../../domain/usecases/perform_scan_upload.dart';
import '../bloc/scan_kulit_bloc.dart';
import '../bloc/scan_kulit_event.dart';
import '../bloc/scan_kulit_state.dart';
import '../widgets/camera_viewfinder.dart';
import '../widgets/camera_controls.dart';
import '../widgets/privacy_banner.dart';

class ScanKulitPage extends StatelessWidget {
  const ScanKulitPage({super.key});

  static const Color primaryGreen = Color(0xFF00BF83);
  static const Color darkGreen = Color(0xFF008D68);
  static const Color textColor = Color(0xFF151918);

  void _showTipsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tips Analisis Kulit AI',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(LucideIcons.x, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _TipItem(
                number: '1',
                title: 'Pencahayaan Cukup',
                subtitle: 'Gunakan cahaya alami atau lampu terang tanpa bayangan pekat.',
              ),
              const SizedBox(height: 12),
              _TipItem(
                number: '2',
                title: 'Posisikan Wajah / Kulit',
                subtitle:
                    'Sejajarkan area kulit di dalam lingkaran pedoman oval.',
              ),
              const SizedBox(height: 12),
              _TipItem(
                number: '3',
                title: 'Pastikan Fokus Jelas',
                subtitle: 'Jaga posisi kamera tetap tenang dan tidak buram saat memotret.',
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final apiClient = context.read<ApiClient>();
        final authLocalDataSource = context.read<AuthLocalDataSource>();
        final scanRemoteDataSource = ScanRemoteDataSourceImpl(
          apiClient: apiClient,
          tokenGetter: () => authLocalDataSource.getToken(),
        );
        final scanRepository = ScanRepositoryImpl(remoteDataSource: scanRemoteDataSource);
        final performScanUpload = PerformScanUpload(scanRepository);

        return ScanKulitBloc(performScanUpload: performScanUpload)
          ..add(const InitializeCameraEvent());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocConsumer<ScanKulitBloc, ScanKulitState>(
            listener: (context, state) {
              if (state.status == ScanStatus.success) {
                context.push(AppRouter.hasilScan, extra: state.scanResult);
              } else if (state.status == ScanStatus.failure) {
                AppStatusDialog.show(
                  context: context,
                  title: 'Gagal Memproses Scan',
                  message: state.errorMessage ?? 'Terjadi kesalahan saat memproses foto',
                  type: AppStatusDialogType.error,
                );
              }
            },

            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(
                            LucideIcons.chevronLeft,
                            size: 24,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'Scan Kulit',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        InkWell(
                          onTap: () => _showTipsBottomSheet(context),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F8F2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF00BF83)
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  LucideIcons.lightbulb,
                                  size: 14,
                                  color: darkGreen,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Tips',
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: darkGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Pilih/Ambil foto wajah yang memperlihatkan area mata, hidung & mulut dengan jelas dan pencahayaan yang cukup agar AI dapat menganalisis.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        height: 1.45,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7B8581),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: CameraViewfinder(isFlashOn: state.isFlashOn),
                    ),
                    const SizedBox(height: 20),
                    CameraControls(
                      isFlashOn: state.isFlashOn,
                      isCapturing: state.status == ScanStatus.capturing,
                      onGalleryTap: () {
                        context.read<ScanKulitBloc>().add(
                          const PickFromGalleryEvent(),
                        );
                      },
                      onCaptureTap: () {
                        context.read<ScanKulitBloc>().add(
                          const CaptureImageEvent(),
                        );
                      },
                      onFlashTap: () {
                        context.read<ScanKulitBloc>().add(
                          const ToggleFlashEvent(),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    const PrivacyBanner(),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;

  const _TipItem({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            color: Color(0xFFE6F8F2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF008D68),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF151918),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.roboto(
                  fontSize: 11,
                  color: const Color(0xFF7B8581),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
