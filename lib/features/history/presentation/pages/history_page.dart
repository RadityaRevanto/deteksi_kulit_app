import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        appBar: AppBar(
          title: const Text('Riwayat Deteksi'),
        ),
        body: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const LoadingWidget(message: 'Memuat riwayat...');
            }

            if (state is HistoryFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Terjadi kesalahan: ${state.message}'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HistoryBloc>().add(HistoryRequested());
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            if (state is HistoryLoaded) {
              if (state.histories.isEmpty) {
                return const Center(
                  child: Text('Belum ada riwayat pemindaian'),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HistoryBloc>().add(HistoryRefreshed());
                },
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
