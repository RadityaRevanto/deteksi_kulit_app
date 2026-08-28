class Subscription {
  final String uuid;
  final String planCode;
  final String period;
  final String status;
  final int amount;
  final String currency;
  final String? paymentMethod;
  final String midtransOrderId;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final DateTime? paidAt;
  final DateTime createdAt;

  const Subscription({
    required this.uuid,
    required this.planCode,
    required this.period,
    required this.status,
    required this.amount,
    required this.currency,
    this.paymentMethod,
    required this.midtransOrderId,
    this.startsAt,
    this.endsAt,
    this.paidAt,
    required this.createdAt,
  });

  bool get isActive =>
      status.toLowerCase() == 'active' &&
      (endsAt == null || endsAt!.isAfter(DateTime.now()));
}

class CheckoutResult {
  final String snapToken;
  final String redirectUrl;
  final Subscription subscription;

  const CheckoutResult({
    required this.snapToken,
    required this.redirectUrl,
    required this.subscription,
  });
}
