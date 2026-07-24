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
        ],
      ),
    );
  }
}
