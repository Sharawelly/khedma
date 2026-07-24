import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/provider_entities.dart';
import '../../domain/usecases/params/provider_params.dart';
import '../../domain/usecases/provider_use_cases.dart';

part 'provider_finance_state.dart';

enum ProviderFinanceAction { load, payout }

class ProviderFinanceCommand {
  const ProviderFinanceCommand._(
    this.action, {
    this.period = 'monthly',
    this.amount,
  });

  const ProviderFinanceCommand.load(String period)
    : this._(ProviderFinanceAction.load, period: period);
  const ProviderFinanceCommand.payout(double amount, String period)
    : this._(ProviderFinanceAction.payout, amount: amount, period: period);

  final ProviderFinanceAction action;
  final String period;
  final double? amount;
}

class ProviderFinanceCubit extends Cubit<ProviderFinanceState> {
  ProviderFinanceCubit({
    required this.getEarnings,
    required this.getWallet,
    required this.requestPayout,
  }) : super(const ProviderFinanceInitial());

  final GetProviderEarnings getEarnings;
  final GetProviderWallet getWallet;
  final RequestProviderPayout requestPayout;
  ProviderEarningsEntity? _earnings;
  ProviderWalletEntity? _wallet;

  Future<void> execute(ProviderFinanceCommand command) async {
    emit(const ProviderFinanceLoading());
    PayoutEntity? payout;
    if (command.action == ProviderFinanceAction.payout) {
      final payoutResult = await requestPayout(
        ProviderPayoutParams(command.amount!),
      );
      final failed = payoutResult.fold<String?>(
        (failure) => failure.message ?? 'provider_payout_failed',
        (value) {
          payout = value;
          return null;
        },
      );
      if (failed != null) {
        emit(ProviderFinanceFailure(failed));
        return;
      }
    }
    final earningsResult = await getEarnings(
      ProviderEarningsParams(command.period),
    );
    final walletResult = await getWallet();
    String? failureMessage;
    final earnings = earningsResult.fold<ProviderEarningsEntity?>((failure) {
      failureMessage = failure.message ?? 'provider_request_failed';
      return null;
    }, (value) => value);
    final wallet = walletResult.fold<ProviderWalletEntity?>((failure) {
      failureMessage ??= failure.message ?? 'provider_request_failed';
      return null;
    }, (value) => value);
    if (earnings == null || wallet == null) {
      if (payout != null && _earnings != null && _wallet != null) {
        emit(
          ProviderFinanceSuccess(
            earnings: _earnings!,
            wallet: _wallet!,
            payout: payout,
          ),
        );
        return;
      }
      emit(ProviderFinanceFailure(failureMessage ?? 'provider_request_failed'));
      return;
    }
    _earnings = earnings;
    _wallet = wallet;
    emit(
      ProviderFinanceSuccess(
        earnings: earnings,
        wallet: wallet,
        payout: payout,
      ),
    );
  }
}
