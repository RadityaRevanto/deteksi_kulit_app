abstract class SubscriptionEvent {
  const SubscriptionEvent();
}

class FetchSubscriptionsEvent extends SubscriptionEvent {
  const FetchSubscriptionsEvent();
}

class CheckoutSubscriptionEvent extends SubscriptionEvent {
  const CheckoutSubscriptionEvent();
}

class CancelSubscriptionEvent extends SubscriptionEvent {
  final String uuid;
  const CancelSubscriptionEvent(this.uuid);
}
