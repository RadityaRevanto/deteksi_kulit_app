import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/routes/app_router.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../dokter/domain/entities/doctor.dart';
import '../../data/datasources/history_remote_data_source.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../domain/usecases/get_history.dart';
import '../bloc/history/history_bloc.dart';
import '../bloc/history/history_event.dart';
import '../bloc/history/history_state.dart';
import '../widgets/history_card.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  static const Color primaryGreen = Color(0xFF00BF83);
  static const Color darkGreen = Color(0xFF008D68);
  static const Color textColor = Color(0xFF151918);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final apiClient = context.read<ApiClient>();
        final dataSource = HistoryRemoteDataSourceImpl(apiClient: apiClient);
        final repository = HistoryRepositoryImpl(remoteDataSource: dataSource);
        final useCase = GetHistory(repository);
        return HistoryBloc(useCase)..add(HistoryRequested());
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0.5,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Text(
              'Riwayat',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            centerTitle: false,
           bottom: TabBar(
              labelColor: darkGreen,
              unselectedLabelColor: const Color(0xFF7B8581),
              indicatorColor: primaryGreen,
              indicatorWeight: 3,
              labelStyle: GoogleFonts.roboto(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: GoogleFonts.roboto(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'Chat Dokter'),
                Tab(text: 'Hasil Scan AI'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Tab 1: Doctor Chat History
              _DoctorChatHistoryTab(),

              // Tab 2: Scan History
              const _ScanHistoryTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanHistoryTab extends StatelessWidget {
  const _ScanHistoryTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state is HistoryLoading) {
          return const LoadingWidget(message: 'Memuat riwayat scan...');
        }

        if (state is HistoryFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    LucideIcons.alertCircle,
                    size: 48,
                    color: Color(0xFFEF4444),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Terjadi Kesalahan',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: HistoryPage.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: const Color(0xFF7B8581),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<HistoryBloc>().add(HistoryRequested());
                    },
                    icon: const Icon(
                      LucideIcons.rotateCw,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Coba Lagi',
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HistoryPage.primaryGreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is HistoryLoaded) {
          if (state.histories.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE6F8F2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.scanLine,
                        size: 36,
                        color: HistoryPage.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum Ada Riwayat Pemindaian',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: HistoryPage.textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Lakukan scan kulit pertama Anda untuk melihat hasil analisis AI di sini.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: const Color(0xFF7B8581),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.push(AppRouter.scanKulit);
                      },
                      icon: const Icon(
                        LucideIcons.camera,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Scan Kulit Sekarang',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HistoryPage.primaryGreen,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<HistoryBloc>().add(HistoryRefreshed());
            },
            color: HistoryPage.primaryGreen,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.histories.length,
              itemBuilder: (context, index) {
                final item = state.histories[index];
                return HistoryCard(
                  history: item,
                  onTap: () {
                    if (item.scanResult != null) {
                      context.push(
                        AppRouter.hasilScan,
                        extra: item.scanResult,
                      );
                    }
                  },
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _DoctorChatHistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiClient = context.read<ApiClient>();

    return FutureBuilder<Map<String, dynamic>>(
      future: apiClient.get('/conversations?per_page=10').catchError((_) => <String, dynamic>{}),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget(message: 'Memuat riwayat chat...');
        }

        final data = snapshot.data;
        final conversations = <Map<String, dynamic>>[];
        if (data != null && data.containsKey('data') && data['data'] is List) {
          for (final item in data['data'] as List) {
            if (item is Map<String, dynamic>) {
              conversations.add(item);
            }
          }
        }

        if (conversations.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE6F8F2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.messageSquare,
                      size: 36,
                      color: HistoryPage.darkGreen,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum Ada Riwayat Konsultasi',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: HistoryPage.textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Mulai chat dengan Dokter spesialis atau AI Aura Skin untuk berkonsultasi mengenai kesehatan kulit Anda.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: const Color(0xFF7B8581),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.push(AppRouter.konfirmasiDokter);
                    },
                    icon: const Icon(
                      LucideIcons.stethoscope,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Konsultasi Dokter Sekarang',
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HistoryPage.darkGreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: conversations.length,
          itemBuilder: (context, index) {
            final conv = conversations[index];
            final doctor = conv['doctor'] as Map<String, dynamic>? ?? {};
            final doctorName = doctor['full_name']?.toString() ?? 'Dokter Spesialis';
            final specialization = doctor['specialization']?.toString() ?? 'Spesialis Kulit';
            final isAi = doctor['is_ai_bot'] == true;

            final lastMsg = conv['last_message'] as Map<String, dynamic>?;
            final lastSnippet = lastMsg?['content']?.toString() ?? 'Ketuk untuk membuka percakapan...';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF0F0F0)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () {
                    final doctorUuid = doctor['uuid']?.toString() ?? '';
                    final convUuid = conv['uuid']?.toString() ?? '';
                    final doctorObj = Doctor(
                      id: doctorUuid,
                      name: doctorName,
                      specialist: specialization,
                      hospital: isAi ? 'SkinCek AI Center' : 'Klinik SkinCek Utama',
                      rating: 4.9,
                      reviewCount: 100,
                      experienceYears: 8,
                      consultationFee: isAi ? 0 : 50000,
                      isOnline: true,
                      avatarUrl: doctor['avatar']?.toString() ?? '',
                      isAiBot: isAi,
                    );
                    context.push(
                      AppRouter.chatRoom,
                      extra: {
                        'doctor': doctorObj,
                        'conversationUuid': convUuid,
                      },
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isAi ? const Color(0xFFF0FDFA) : const Color(0xFFE6F8F2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isAi ? LucideIcons.bot : LucideIcons.userCheck,
                            color: HistoryPage.darkGreen,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      doctorName,
                                      style: GoogleFonts.roboto(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w700,
                                        color: HistoryPage.textColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isAi)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE0F2FE),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'AI Bot',
                                        style: GoogleFonts.roboto(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF0369A1),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                specialization,
                                style: GoogleFonts.roboto(
                                  fontSize: 11.5,
                                  color: const Color(0xFF008D68),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lastSnippet,
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  color: const Color(0xFF7B8581),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          LucideIcons.chevronRight,
                          size: 18,
                          color: Color(0xFF94A3B8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
