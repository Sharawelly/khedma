import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/injection_container.dart';

class ProviderAvailabilityEarningsCard extends StatelessWidget {
  const ProviderAvailabilityEarningsCard({
    super.key,
    required this.isOnline,
    required this.onChanged,
  });

  final bool isOnline;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(16.w),
      decoration: BoxDecoration(
        color: colors.authBrandRed,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.shadowCardLight,
            blurRadius: 12,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'provider_availability_label'.tr,
                      style: TextStyles.regular13(color: colors.whiteColor),
                    ),
                    Gaps.vGap4,
                    Text(
                      isOnline
                          ? 'provider_status_online'.tr
                          : 'provider_status_offline'.tr,
                      style: TextStyles.bold20(color: colors.whiteColor),
                    ),
                  ],
                ),
              ),
              CupertinoSwitch(
                value: isOnline,
                onChanged: onChanged,
                activeTrackColor: colors.strengthStrong,
                inactiveTrackColor: colors.whiteColor.withValues(alpha: 0.45),
                thumbColor: colors.whiteColor,
              ),
            ],
          ),
          Gaps.vGap12,
          Container(
            height: 1,
            color: colors.whiteColor.withValues(alpha: 0.3),
          ),
          Gaps.vGap12,
          Row(
            children: <Widget>[
              Expanded(
                child: _StatBlock(
                  labelKey: 'provider_stat_jobs',
                  valueKey: 'provider_jobs_count_value',
                ),
              ),
              _VerticalLine(),
              Expanded(
                child: _StatBlock(
                  labelKey: 'provider_stat_earnings',
                  valueKey: 'provider_earnings_value',
                ),
              ),
              _VerticalLine(),
              Expanded(
                child: _StatBlock(
                  labelKey: 'provider_stat_rating',
                  valueKey: 'provider_rating_value',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VerticalLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40.h,
      color: colors.whiteColor.withValues(alpha: 0.35),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.labelKey, required this.valueKey});

  final String labelKey;
  final String valueKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          labelKey.tr,
          style: TextStyles.regular10(color: colors.whiteColor),
        ),
        Gaps.vGap4,
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            valueKey.tr,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyles.bold16(color: colors.whiteColor),
          ),
        ),
      ],
    );
  }
}
