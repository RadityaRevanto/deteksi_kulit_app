import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/widgets/loading_widget.dart';
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
        final dataSource = HistoryRemoteDataSourceImpl();
        final repository = HistoryRepositoryImpl(remoteDataSource: dataSource);
        final useCase = GetHistory(repository);
        return HistoryBloc(useCase)..add(HistoryRequested());
      },
      child: Scaffold(
        backgroundColor:  Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              'Riwayat Deteksi',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
          centerTitle: false,
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    context.read<HistoryBloc>().add(HistoryRefreshed());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Memperbarui riwayat...'),
                        duration: Duration(seconds: 1),
                        backgroundColor: darkGreen,
                      ),
                    );
                  },
                  icon: const Icon(
                    LucideIcons.rotateCw,
                    size: 20,
                    color: textColor,
                  ),
                  tooltip: 'Muat Ulang',
                );
              },
            ),
            const SizedBox(width: 8),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: const Color(0xFFF0F0F0),
              height: 1.0,
            ),
          ),
        ),
        body: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const LoadingWidget(message: 'Memuat riwayat...');
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
                          color: textColor,
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
                          backgroundColor: primaryGreen,
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
                          LucideIcons.clock3,
                          size: 36,
                          color: darkGreen,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum Ada Riwayat Pemindaian',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Lakukan scan kulit pertama Anda untuk melihat hasil di sini.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: const Color(0xFF7B8581),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HistoryBloc>().add(HistoryRefreshed());
                },
                color: primaryGreen,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.histories.length,
                  itemBuilder: (context, index) {
                    final item = state.histories[index];
                    return HistoryCard(history: item);
                  },
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
