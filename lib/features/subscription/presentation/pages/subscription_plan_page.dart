import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/routes/app_router.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../data/datasources/subscription_remote_data_source.dart';
import '../bloc/subscription_bloc.dart';
import '../bloc/subscription_event.dart';
import '../bloc/subscription_state.dart';

class SubscriptionPlanPage extends StatelessWidget {
  const SubscriptionPlanPage({super.key});

  static const Color primaryGreen = Color(0xFF00BF83);
  static const Color darkGreen = Color(0xFF008D68);
  static const Color textColor = Color(0xFF101828);
  static const Color orangeColor = Color(0xFFF97316);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final apiClient = context.read<ApiClient>();
        final dataSource = SubscriptionRemoteDataSourceImpl(apiClient: apiClient);
        return SubscriptionBloc(remoteDataSource: dataSource)
          ..add(const FetchSubscriptionsEvent());
      },
      child: BlocConsumer<SubscriptionBloc, SubscriptionState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: const Color(0xFFEF4444),
              ),
            );
          }

          if (state.status == SubscriptionStatus.checkoutSuccess && state.checkoutResult != null) {
            context.push(
              AppRouter.paymentWebview,
              extra: state.checkoutResult!.redirectUrl,
            );
          }
        },
        builder: (context, state) {
          final isPro = state.activeSubscription != null;

          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              titleSpacing: 0,
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(LucideIcons.chevronLeft, color: textColor),
              ),
              title: Text(
                'Langganan SkinCek Pro',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              centerTitle: false,
            ),
            body: state.status == SubscriptionStatus.loading
                ? const LoadingWidget(message: 'Memproses data langganan...')
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Header Banner Box with Pricing & Plan Title
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF008D68), Color(0xFF00BF83)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1A00BF83),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      LucideIcons.crown,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      isPro ? 'SkinCek PRO Aktif ✨' : 'SkinCek Pro Monthly',
                                      style: GoogleFonts.roboto(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  if (!isPro)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEF3C7),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'HEMAT 80%',
                                        style: GoogleFonts.roboto(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFD97706),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              // Pricing Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    'Rp 15.000',
                                    style: GoogleFonts.roboto(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    ' / bulan',
                                    style: GoogleFonts.roboto(
                                      fontSize: 13,
                                      color: Colors.white.withValues(alpha: 0.85),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Rp 180.000',
                                    style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      color: Colors.white.withValues(alpha: 0.6),
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Colors.white.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isPro
                                    ? 'Selamat! Akun Anda aktif menikmati seluruh akses fitur premium.'
                                    : 'Akses tanpa batas untuk Scan ML Kulit, Chat Dokter Spesialis, & Aura Skin AI 24/7.',
                                style: GoogleFonts.roboto(
                                  fontSize: 11.5,
                                  color: Colors.white.withValues(alpha: 0.9),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Active Subscription Expiry Card if Pro
                        if (isPro && state.activeSubscription!.endsAt != null) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F8F2),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: primaryGreen),
                            ),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.checkCircle2, color: darkGreen, size: 22),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Paket Pro Aktif',
                                        style: GoogleFonts.roboto(fontSize: 13.5, fontWeight: FontWeight.bold, color: darkGreen),
                                      ),
                                      Text(
                                        'Berlaku hingga: ${state.activeSubscription!.endsAt!.day}/${state.activeSubscription!.endsAt!.month}/${state.activeSubscription!.endsAt!.year}',
                                        style: GoogleFonts.roboto(fontSize: 11, color: const Color(0xFF475569)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Features List Section Header
                        Text(
                          'Keuntungan SkinCek Pro',
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Features List Cards
                        _buildFeatureTile(
                          icon: LucideIcons.scanLine,
                          title: 'Scan Kulit ML Tanpa Batas',
                          description: 'Bebas melakukan prediksi diagnosa kulit kapan saja tanpa batas 3x/hari.',
                        ),
                        _buildFeatureTile(
                          icon: LucideIcons.messageSquare,
                          title: 'Chat Dokter Spesialis Tanpa Batas',
                          description: 'Konsultasi langsung dengan dokter kulit terverifikasi tanpa batasan kuota.',
                        ),
                        _buildFeatureTile(
                          icon: LucideIcons.bot,
                          title: 'Chat Aura Skin AI 24/7 Tanpa Batas',
                          description: 'Tanyakan rekomendasi skincare dan tips perawatan ke asisten AI tanpa batas 10 pesan/hari.',
                        ),
                      ],
                    ),
                  ),

            // Sticky Bottom Action Navigation Bar
            bottomNavigationBar: isPro
                ? null
                : Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 12,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Pembayaran',
                                  style: GoogleFonts.roboto(
                                    fontSize: 11,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      'Rp 15.000',
                                      style: GoogleFonts.roboto(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: orangeColor,
                                      ),
                                    ),
                                    Text(
                                      ' /bln',
                                      style: GoogleFonts.roboto(
                                        fontSize: 11,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 46,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.push(
                                    AppRouter.paymentWebview,
                                    extra: '',
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(LucideIcons.crown, color: Colors.white, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Upgrade SkinCek Pro',
                                      style: GoogleFonts.roboto(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: const BoxDecoration(
              color: Color(0xFFE6F8F2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: darkGreen, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.roboto(
                    fontSize: 11.5,
                    color: const Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
