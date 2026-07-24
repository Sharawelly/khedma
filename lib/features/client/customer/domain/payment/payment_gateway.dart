import '../usecases/params/customer_params.dart';

enum PaymentOutcome { pendingCash }

abstract class PaymentGateway {
  Future<PaymentOutcome> prepare(BookingDraft booking);
}

class NoOpPaymentGateway implements PaymentGateway {
  const NoOpPaymentGateway();

  @override
  Future<PaymentOutcome> prepare(BookingDraft booking) async {
    return PaymentOutcome.pendingCash;
  }
}
