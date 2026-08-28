import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/subscription_remote_data_source.dart';
import '../../domain/entities/subscription.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRemoteDataSource remoteDataSource;

  SubscriptionBloc({required this.remoteDataSource})
      : super(const SubscriptionState()) {
    on<FetchSubscriptionsEvent>(_onFetchSubscriptions);
    on<CheckoutSubscriptionEvent>(_onCheckout);
    on<CancelSubscriptionEvent>(_onCancel);
  }

  Future<void> _onFetchSubscriptions(
    FetchSubscriptionsEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(state.copyWith(status: SubscriptionStatus.loading));
    try {
      final list = await remoteDataSource.getSubscriptions();
      Subscription? activeSub;
      for (final sub in list) {
        if (sub.isActive) {
          activeSub = sub;
          break;
        }
      }
      emit(state.copyWith(
        status: SubscriptionStatus.success,
        subscriptions: list,
        activeSubscription: activeSub,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SubscriptionStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onCheckout(
    CheckoutSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(state.copyWith(status: SubscriptionStatus.loading));
    try {
      final res = await remoteDataSource.checkout();
      emit(state.copyWith(
        status: SubscriptionStatus.checkoutSuccess,
        checkoutResult: res,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SubscriptionStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onCancel(
    CancelSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(state.copyWith(status: SubscriptionStatus.loading));
    try {
      await remoteDataSource.cancelSubscription(event.uuid);
      add(const FetchSubscriptionsEvent());
    } catch (e) {
      emit(state.copyWith(
        status: SubscriptionStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
