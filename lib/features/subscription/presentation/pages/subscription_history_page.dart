import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../data/datasources/subscription_remote_data_source.dart';
import '../bloc/subscription_bloc.dart';
import '../bloc/subscription_event.dart';
import '../bloc/subscription_state.dart';
import '../widgets/subscription_card.dart';

class SubscriptionHistoryPage extends StatelessWidget {
  const SubscriptionHistoryPage({super.key});

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
      child: Scaffold(
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
            'Riwayat Langganan Pro',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          centerTitle: false,
        ),
        body: BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (context, state) {
            if (state.status == SubscriptionStatus.loading) {
              return const LoadingWidget(message: 'Memuat riwayat langganan...');
            }

            if (state.subscriptions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.receipt, size: 48, color: Color(0xFF94A3B8)),
                    const SizedBox(height: 12),
                    Text(
                      'Belum ada riwayat transaksi langganan.',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.subscriptions.length,
              itemBuilder: (context, index) {
                final sub = state.subscriptions[index];
                return SubscriptionCard(
                  subscription: sub,
                  onCancel: () {
                    context.read<SubscriptionBloc>().add(
                          CancelSubscriptionEvent(sub.uuid),
                        );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
