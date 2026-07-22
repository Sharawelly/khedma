import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/app_centered_header_bar.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/injection_container.dart';

class ProviderReviewsScreen extends StatelessWidget {
  const ProviderReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      body: Column(
        children: <Widget>[
          AppCenteredHeaderBar(
            title: 'provider_my_reviews'.tr,
            onBack: () => context.pop(),
            showBottomBorder: false,
            // trailing: IconButton(
            //   onPressed: () {},
            //   icon: Icon(
            //     Icons.more_vert_rounded,
            //     size: 20.r,
            //     color: colors.onboardingHeadline,
            //   ),
            // ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsetsDirectional.fromSTEB(16.w, 10.h, 16.w, 20.h),
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsetsDirectional.all(16.w),
                  decoration: BoxDecoration(
                    color: colors.whiteColor,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: colors.onboardingBorderNeutral),
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        '4.9',
                        style: TextStyles.bold32(color: colors.authBrandRed),
                      ),
                      Gaps.vGap4,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(
                          5,
                          (int _) => Icon(
                            Icons.star_rounded,
                            color: colors.review,
                            size: 18.r,
                          ),
                        ),
                      ),
                      Gaps.vGap4,
                      Text(
                        'provider_reviews_total'.tr,
                        style: TextStyles.regular14(
                          color: colors.lightTextColor,
                        ),
                      ),
                      Gaps.vGap12,
                      const _ProviderRatingBarRow(stars: 5, value: 0.90),
                      Gaps.vGap6,
                      const _ProviderRatingBarRow(stars: 4, value: 0.07),
                      Gaps.vGap6,
                      const _ProviderRatingBarRow(stars: 3, value: 0.02),
                      Gaps.vGap6,
                      const _ProviderRatingBarRow(stars: 2, value: 0.01),
                      Gaps.vGap6,
                      const _ProviderRatingBarRow(stars: 1, value: 0.0),
                    ],
                  ),
                ),
                Gaps.vGap16,
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'provider_recent_feedback'.tr,
                        style: TextStyles.bold20(
                          color: colors.onboardingHeadline,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.filter_list_rounded,
                          size: 16.r,
                          color: colors.authBrandRed,
                        ),
                        Gaps.hGap4,
                        Text(
                          'provider_reviews_filter'.tr,
                          style: TextStyles.semiBold14(
                            color: colors.authBrandRed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Gaps.vGap12,
                const _ProviderReviewCard(
                  nameKey: 'provider_review_name_1',
                  dateKey: 'provider_review_date_1',
                  commentKey: 'provider_review_comment_1',
                  replyKey: 'provider_review_reply_1',
                  showWriteReply: false,
                ),
                Gaps.vGap12,
                const _ProviderReviewCard(
                  nameKey: 'provider_review_name_2',
                  dateKey: 'provider_review_date_2',
                  commentKey: 'provider_review_comment_2',
                  showWriteReply: true,
                ),
                Gaps.vGap12,
                const _ProviderReviewCard(
                  nameKey: 'provider_review_name_3',
                  dateKey: 'provider_review_date_3',
                  commentKey: 'provider_review_comment_3',
                  replyKey: 'provider_review_reply_3',
                  showWriteReply: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderReviewCard extends StatelessWidget {
  const _ProviderReviewCard({
    required this.nameKey,
    required this.dateKey,
    required this.commentKey,
    this.replyKey,
    required this.showWriteReply,
  });

  final String nameKey;
  final String dateKey;
  final String commentKey;
  final String? replyKey;
  final bool showWriteReply;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(14.w),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 18.r,
                backgroundColor: colors.mainAlpha20,
                child: Icon(Icons.person, size: 18.r, color: colors.main),
              ),
              Gaps.hGap8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      nameKey.tr,
                      style: TextStyles.semiBold15(
                        color: colors.onboardingHeadline,
                      ),
                    ),
                    Text(
                      dateKey.tr,
                      style: TextStyles.regular12(color: colors.homeCaption),
                    ),
                  ],
                ),
              ),
              Row(
                children: List<Widget>.generate(
                  5,
                  (int _) => Icon(
                    Icons.star_rounded,
                    color: colors.review,
                    size: 14.r,
                  ),
                ),
              ),
            ],
          ),
          Gaps.vGap10,
          Text(
            commentKey.tr,
            style: TextStyles.regular14(color: colors.onboardingBody),
          ),
          if (replyKey != null) ...<Widget>[
            Gaps.vGap10,
            Container(
              width: double.infinity,
              padding: EdgeInsetsDirectional.all(10.w),
              decoration: BoxDecoration(
                color: colors.authBrandRed.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '${'provider_your_reply'.tr}: ${replyKey!.tr}',
                style: TextStyles.regular13(color: colors.onboardingHeadline),
              ),
            ),
          ],
          if (showWriteReply) ...<Widget>[
            Gaps.vGap10,
            Row(
              children: <Widget>[
                Icon(
                  Icons.reply_rounded,
                  size: 15.r,
                  color: colors.authBrandRed,
                ),
                Gaps.hGap4,
                Text(
                  'provider_reviews_write_reply'.tr,
                  style: TextStyles.semiBold14(color: colors.authBrandRed),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ProviderRatingBarRow extends StatelessWidget {
  const _ProviderRatingBarRow({required this.stars, required this.value});

  final int stars;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 12.w,
          child: Text(
            '$stars',
            style: TextStyles.regular12(color: colors.lightTextColor),
          ),
        ),
        Gaps.hGap8,
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6.h,
              backgroundColor: colors.onboardingSurfaceMuted,
              valueColor: AlwaysStoppedAnimation<Color>(colors.authBrandRed),
            ),
          ),
        ),
        Gaps.hGap8,
        SizedBox(
          width: 36.w,
          child: Text(
            '${(value * 100).toStringAsFixed(0)}%',
            textAlign: TextAlign.end,
            style: TextStyles.regular12(color: colors.homeCaption),
          ),
        ),
      ],
    );
  }
}
