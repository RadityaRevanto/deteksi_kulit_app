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
                ? const LoadingWidget(message: 'Memproses transaksi...')
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Banner Box
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
                                color: Color(0x2000BF83),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  LucideIcons.crown,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                isPro ? 'Status Akun: SkinCek PRO ✨' : 'Nikmati Fitur Kesehatan Kulit Tanpa Batas',
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                isPro
                                    ? 'Selamat! Akun kamu aktif berlangganan Pro.'
                                    : 'Dapatkan akses tak terbatas untuk scan ML, chat dokter spesialis, dan asisten AI Aura Skin.',
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Active Subscription Banner if Pro
                        if (isPro) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F8F2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: primaryGreen),
                            ),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.checkCircle2, color: darkGreen, size: 24),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Paket Pro Aktif',
                                        style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold, color: darkGreen),
                                      ),
                                      if (state.activeSubscription!.endsAt != null)
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

                        // Features List Title
                        Text(
                          'Keuntungan SkinCek Pro',
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Features Comparison Cards
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
                        const SizedBox(height: 24),
                        // Pricing Card
                        if (!isPro) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: primaryGreen, width: 2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0C000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'SkinCek Pro Monthly',
                                          style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                        Text(
                                          'Langganan 30 Hari (Otomatis memperpanjang)',
                                          style: GoogleFonts.roboto(
                                            fontSize: 11,
                                            color: const Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      'Rp 15.000',
                                      style: GoogleFonts.roboto(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: darkGreen,
                                      ),
                                    ),
                                    Text(
                                      ' / bulan',
                                      style: GoogleFonts.roboto(
                                        fontSize: 13,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context.read<SubscriptionBloc>().add(
                                            const CheckoutSubscriptionEvent(),
                                          );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryGreen,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(LucideIcons.creditCard, color: Colors.white, size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Upgrade ke SkinCek Pro',
                                          style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFE6F8F2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: darkGreen, size: 18),
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
