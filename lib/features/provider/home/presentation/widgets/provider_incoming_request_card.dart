import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/core/widgets/my_default_button.dart';
import 'package:khedma/injection_container.dart';
import 'package:khedma/features/provider/domain/entities/provider_entities.dart';

class ProviderIncomingRequestCard extends StatelessWidget {
  const ProviderIncomingRequestCard({
    super.key,
    required this.job,
    this.onTap,
    this.onDecline,
    this.onAccept,
  });

  final PendingJobEntity job;
  final VoidCallback? onTap;
  final VoidCallback? onDecline;
  final VoidCallback? onAccept;

  @override
  Widget build(BuildContext context) {
    final isArabic = appLocalizations.isArLocale;
    return Material(
      color: colors.whiteColor,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          width: double.infinity,
          padding: EdgeInsetsDirectional.all(14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: colors.authBrandRed, width: 1.2),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: colors.shadowCardLight,
                blurRadius: 8,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 48.r,
                    height: 48.r,
                    decoration: BoxDecoration(
                      color: colors.authSignUpSelectedSurface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.plumbing_rounded,
                      size: 24.r,
                      color: colors.authBrandRed,
                    ),
                  ),
                  Gaps.hGap12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          job.localizedService(isArabic),
                          style: TextStyles.semiBold16(
                            color: colors.onboardingTextStrong,
                          ),
                        ),
                        Gaps.vGap4,
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on_outlined,
                              size: 14.r,
                              color: colors.homeCaption,
                            ),
                            Gaps.hGap4,
                            Expanded(
                              child: Text(
                                '${job.distanceKm.toStringAsFixed(1)} ${'provider_km'.tr}',
                                style: TextStyles.regular12(
                                  color: colors.homeCaption,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '${job.providerEarning.toStringAsFixed(2)} ${job.currency}',
                        style: TextStyles.bold16(color: colors.authBrandRed),
                      ),
                      Gaps.vGap2,
                      Text(
                        'provider_earnings_net_label'.tr,
                        style: TextStyles.regular10(color: colors.homeCaption),
                      ),
                    ],
                  ),
                ],
              ),
              Gaps.vGap12,
              Row(
                children: <Widget>[
                  Expanded(
                    child: MyDefaultButton(
                      btnText: 'provider_decline'.tr,
                      localeText: true,
                      onPressed: onDecline ?? () {},
                      color: colors.whiteColor,
                      textColor: colors.onboardingTextStrong,
                      borderColor: colors.onboardingBorderNeutral,
                      borderRadius: 12,
                      height: 38.h,
                      textStyle: TextStyles.semiBold14(
                        color: colors.onboardingTextStrong,
                      ),
                    ),
                  ),
                  Gaps.hGap10,
                  Expanded(
                    child: MyDefaultButton(
                      btnText: 'provider_accept'.tr,
                      localeText: true,
                      onPressed: onAccept ?? () {},
                      color: colors.authBrandRed,
                      textColor: colors.whiteColor,
                      borderColor: colors.authBrandRed,
                      borderRadius: 12,
                      height: 38.h,
                      textStyle: TextStyles.semiBold14(
                        color: colors.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
