part of 'provider_finance_cubit.dart';

sealed class ProviderFinanceState extends Equatable {
  const ProviderFinanceState();

  @override
  List<Object?> get props => <Object?>[];
}

class ProviderFinanceInitial extends ProviderFinanceState {
  const ProviderFinanceInitial();
}

class ProviderFinanceLoading extends ProviderFinanceState {
  const ProviderFinanceLoading();
}

class ProviderFinanceSuccess extends ProviderFinanceState {
  const ProviderFinanceSuccess({
    required this.earnings,
    required this.wallet,
    this.payout,
  });

  final ProviderEarningsEntity earnings;
  final ProviderWalletEntity wallet;
  final PayoutEntity? payout;

  @override
  List<Object?> get props => <Object?>[earnings, wallet, payout];
}

class ProviderFinanceFailure extends ProviderFinanceState {
  const ProviderFinanceFailure(this.message);
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
