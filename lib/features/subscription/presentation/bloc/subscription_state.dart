import '../../domain/entities/subscription.dart';

enum SubscriptionStatus { initial, loading, success, failure, checkoutSuccess }

class SubscriptionState {
  final SubscriptionStatus status;
  final List<Subscription> subscriptions;
  final Subscription? activeSubscription;
  final CheckoutResult? checkoutResult;
  final String? errorMessage;

  const SubscriptionState({
    this.status = SubscriptionStatus.initial,
    this.subscriptions = const [],
    this.activeSubscription,
    this.checkoutResult,
    this.errorMessage,
  });

  SubscriptionState copyWith({
    SubscriptionStatus? status,
    List<Subscription>? subscriptions,
    Subscription? activeSubscription,
    CheckoutResult? checkoutResult,
    String? errorMessage,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      subscriptions: subscriptions ?? this.subscriptions,
      activeSubscription: activeSubscription ?? this.activeSubscription,
      checkoutResult: checkoutResult ?? this.checkoutResult,
      errorMessage: errorMessage,
    );
  }
}
