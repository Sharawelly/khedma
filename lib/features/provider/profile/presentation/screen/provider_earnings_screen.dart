import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';
import '../../../domain/entities/provider_entities.dart';
import '../../../presentation/cubit/provider_finance_cubit.dart';
import '../../../presentation/widgets/provider_state_widgets.dart';

class ProviderEarningsScreen extends StatefulWidget {
  const ProviderEarningsScreen({super.key});

  @override
  State<ProviderEarningsScreen> createState() => _ProviderEarningsScreenState();
}

class _ProviderEarningsScreenState extends State<ProviderEarningsScreen> {
  String _period = 'monthly';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProviderFinanceCubit>(
      create: (_) =>
          ServiceLocator.instance<ProviderFinanceCubit>()
            ..execute(ProviderFinanceCommand.load(_period)),
      child: Builder(
        builder: (context) =>
            BlocConsumer<ProviderFinanceCubit, ProviderFinanceState>(
              listener: (context, state) {
                if (state is ProviderFinanceSuccess && state.payout != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('provider_payout_requested'.tr)),
                  );
                }
              },
              builder: (context, state) => Scaffold(
                appBar: AppBar(
                  title: Text('provider_my_earnings'.tr),
                  leading: BackButton(onPressed: context.pop),
                ),
                body: _body(context, state),
              ),
            ),
      ),
    );
  }

  Widget _body(BuildContext context, ProviderFinanceState state) {
    if (state is ProviderFinanceFailure) {
      return ProviderErrorView(state.message);
    }
    if (state is! ProviderFinanceSuccess) {
      return const ProviderLoadingView();
    }
    final earnings = state.earnings;
    final wallet = state.wallet;
    return RefreshIndicator(
      onRefresh: () => context.read<ProviderFinanceCubit>().execute(
        ProviderFinanceCommand.load(_period),
      ),
      child: ListView(
        padding: EdgeInsetsDirectional.all(16.r),
        children: <Widget>[
          _periodSelector(context),
          Gaps.vGap16,
          _MoneySummary(earnings: earnings),
          Gaps.vGap16,
          _WalletSummary(wallet: wallet),
          Gaps.vGap20,
          Text(
            'provider_earnings_breakdown'.tr,
            style: TextStyles.bold20(color: colors.onboardingHeadline),
          ),
          Gaps.vGap10,
          if (earnings.breakdown.isEmpty)
            Text(
              'provider_no_earnings_breakdown'.tr,
              textAlign: TextAlign.center,
              style: TextStyles.medium16(color: colors.homeCaption),
            )
          else
            ...earnings.breakdown.map(
              (item) => _BreakdownCard(item: item, currency: earnings.currency),
            ),
          Gaps.vGap20,
          Text(
            'provider_earnings_payout_history'.tr,
            style: TextStyles.bold20(color: colors.onboardingHeadline),
          ),
          Gaps.vGap10,
          if (wallet.recentPayouts.isEmpty)
            Text(
              'provider_no_payouts'.tr,
              textAlign: TextAlign.center,
              style: TextStyles.medium16(color: colors.homeCaption),
            )
          else
            ...wallet.recentPayouts.map(
              (payout) =>
                  _PayoutCard(payout: payout, currency: wallet.currency),
            ),
          Gaps.vGap16,
          FilledButton(
            onPressed: wallet.availableBalance > 0
                ? () => _requestPayout(context, wallet.availableBalance)
                : null,
            child: Text('provider_earnings_request_early_payout'.tr),
          ),
          Gaps.vGap20,
        ],
      ),
    );
  }

  Widget _periodSelector(BuildContext context) {
    const periods = <String>['daily', 'weekly', 'monthly', 'all'];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.w,
      children: periods.map((period) {
        return ChoiceChip(
          label: Text('provider_earnings_$period'.tr),
          selected: _period == period,
          onSelected: (_) {
            setState(() => _period = period);
            context.read<ProviderFinanceCubit>().execute(
              ProviderFinanceCommand.load(period),
            );
          },
        );
      }).toList(),
    );
  }

  Future<void> _requestPayout(
    BuildContext context,
    double availableBalance,
  ) async {
    final controller = TextEditingController();
    final amount = await showDialog<double>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('provider_request_payout_title'.tr),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'provider_payout_amount'.tr,
            helperText:
                '${'provider_available_balance'.tr}: '
                '${availableBalance.toStringAsFixed(2)}',
          ),
        ),
        actions: <Widget>[
          TextButton(onPressed: dialogContext.pop, child: Text('cancel'.tr)),
          FilledButton(
            onPressed: () {
              final value = double.tryParse(controller.text.trim());
              if (value != null && value > 0 && value <= availableBalance) {
                dialogContext.pop(value);
              }
            },
            child: Text('provider_request_payout_action'.tr),
          ),
        ],
      ),
    );
    controller.dispose();
    if (amount != null && context.mounted) {
      await context.read<ProviderFinanceCubit>().execute(
        ProviderFinanceCommand.payout(amount, _period),
      );
    }
  }
}

class _MoneySummary extends StatelessWidget {
  const _MoneySummary({required this.earnings});

  final ProviderEarningsEntity earnings;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      children: <Widget>[
        _money(
          'provider_gross_earnings'.tr,
          earnings.totalGross,
          earnings.currency,
        ),
        _money(
          'provider_commission_deducted'.tr,
          earnings.totalCommissionDeducted,
          earnings.currency,
        ),
        _money(
          'provider_net_earnings'.tr,
          earnings.totalEarned,
          earnings.currency,
        ),
        _text(
          'provider_commission_rate'.tr,
          earnings.commissionRate.toString(),
        ),
        _text('provider_bookings_count'.tr, earnings.bookingsCount.toString()),
      ],
    );
  }
}

class _WalletSummary extends StatelessWidget {
  const _WalletSummary({required this.wallet});

  final ProviderWalletEntity wallet;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      children: <Widget>[
        _money(
          'provider_available_balance'.tr,
          wallet.availableBalance,
          wallet.currency,
        ),
        _money(
          'provider_pending_balance'.tr,
          wallet.pendingBalance,
          wallet.currency,
        ),
        _money(
          'provider_total_withdrawn'.tr,
          wallet.totalWithdrawn,
          wallet.currency,
        ),
        if (wallet.nextPayoutDate != null)
          _text(
            'provider_next_payout_date'.tr,
            wallet.nextPayoutDate!.toLocal().toString(),
          ),
      ],
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(16.r),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Column(children: children),
    );
  }
}

Widget _money(String label, double amount, String currency) =>
    _text(label, '${amount.toStringAsFixed(2)} $currency');

Widget _text(String label, String value) => Padding(
  padding: EdgeInsetsDirectional.only(bottom: 8.h),
  child: Row(
    children: <Widget>[
      Expanded(
        child: Text(
          label,
          style: TextStyles.medium16(color: colors.onboardingBody),
        ),
      ),
      Text(value, style: TextStyles.bold16(color: colors.onboardingHeadline)),
    ],
  ),
);

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({required this.item, required this.currency});

  final EarningsBreakdownEntity item;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colors.whiteColor,
      child: Padding(
        padding: EdgeInsetsDirectional.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              item.serviceName,
              style: TextStyles.bold16(color: colors.onboardingHeadline),
            ),
            Text(
              item.date.toLocal().toString(),
              style: TextStyles.regular12(color: colors.homeCaption),
            ),
            Gaps.vGap8,
            _money('provider_gross_earnings'.tr, item.gross, currency),
            _money(
              'provider_commission_deducted'.tr,
              item.commission,
              currency,
            ),
            _money('provider_net_earnings'.tr, item.net, currency),
          ],
        ),
      ),
    );
  }
}

class _PayoutCard extends StatelessWidget {
  const _PayoutCard({required this.payout, required this.currency});

  final PayoutEntity payout;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colors.whiteColor,
      child: ListTile(
        title: Text('${payout.amount.toStringAsFixed(2)} $currency'),
        subtitle: Text(payout.requestedAt.toLocal().toString()),
        trailing: Text(payout.status),
      ),
    );
  }
}
