import '../../domain/entities/subscription.dart';

class SubscriptionModel extends Subscription {
  const SubscriptionModel({
    required super.uuid,
    required super.planCode,
    required super.period,
    required super.status,
    required super.amount,
    required super.currency,
    super.paymentMethod,
    required super.midtransOrderId,
    super.startsAt,
    super.endsAt,
    super.paidAt,
    required super.createdAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic val) {
      if (val == null) return DateTime.now();
      try {
        return DateTime.parse(val.toString());
      } catch (_) {
        return DateTime.now();
      }
    }

    DateTime? parseNullableDate(dynamic val) {
      if (val == null) return null;
      try {
        return DateTime.parse(val.toString());
      } catch (_) {
        return null;
      }
    }

    return SubscriptionModel(
      uuid: json['uuid']?.toString() ?? '',
      planCode: json['plan_code']?.toString() ?? 'pro_monthly',
      period: json['period']?.toString() ?? 'monthly',
      status: json['status']?.toString() ?? 'pending',
      amount: int.tryParse(json['amount']?.toString() ?? '15000') ?? 15000,
      currency: json['currency']?.toString() ?? 'IDR',
      paymentMethod: json['payment_method']?.toString(),
      midtransOrderId: json['midtrans_order_id']?.toString() ?? '',
      startsAt: parseNullableDate(json['starts_at']),
      endsAt: parseNullableDate(json['ends_at']),
      paidAt: parseNullableDate(json['paid_at']),
      createdAt: parseDate(json['created_at']),
    );
  }
}

class CheckoutResultModel extends CheckoutResult {
  const CheckoutResultModel({
    required super.snapToken,
    required super.redirectUrl,
    required super.subscription,
  });

  factory CheckoutResultModel.fromJson(Map<String, dynamic> json) {
    final subMap = json['subscription'] as Map<String, dynamic>? ?? {};
    return CheckoutResultModel(
      snapToken: json['snap_token']?.toString() ?? '',
      redirectUrl: json['redirect_url']?.toString() ?? '',
      subscription: SubscriptionModel.fromJson(subMap),
    );
  }
}
