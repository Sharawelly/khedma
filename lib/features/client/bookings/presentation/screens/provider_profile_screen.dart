import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/features/client/customer/domain/entities/customer_entities.dart';
import '/features/client/customer/domain/usecases/params/customer_params.dart';
import '/features/client/customer/presentation/cubit/provider_profile_cubit.dart';
import '/features/client/customer/presentation/widgets/customer_state_widgets.dart';
import '/injection_container.dart';

class ProviderProfileScreen extends StatelessWidget {
  const ProviderProfileScreen({
    super.key,
    required this.providerId,
    this.serviceId,
  });

  final String providerId;
  final String? serviceId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProviderProfileCubit>(
      create: (_) => ServiceLocator.instance()
        ..execute(
          ProviderProfileCommand(ProviderProfileAction.load, providerId),
        ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('provider_profile_title'.tr),
          leading: BackButton(onPressed: context.pop),
          actions: <Widget>[
            Builder(
              builder: (context) =>
                  BlocBuilder<ProviderProfileCubit, ProviderProfileState>(
                    builder: (_, state) => IconButton(
                      onPressed: () =>
                          context.read<ProviderProfileCubit>().execute(
                            ProviderProfileCommand(
                              ProviderProfileAction.favorite,
                              providerId,
                            ),
                          ),
                      icon: Icon(
                        state is ProviderProfileSuccess && state.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                      ),
                    ),
                  ),
            ),
          ],
        ),
        body: BlocBuilder<ProviderProfileCubit, ProviderProfileState>(
          builder: (_, state) {
            if (state is ProviderProfileFailure) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomerErrorView(state.message),
                  Builder(
                    builder: (context) => TextButton(
                      onPressed: () =>
                          context.read<ProviderProfileCubit>().execute(
                            ProviderProfileCommand(
                              ProviderProfileAction.load,
                              providerId,
                            ),
                          ),
                      child: Text('retry'.tr),
                    ),
                  ),
                ],
              );
            }
            if (state is! ProviderProfileSuccess) {
              return const CustomerLoadingView();
            }
            return _ProfileBody(
              profile: state.profile,
              reviews: state.reviews,
              reviewsHaveNextPage: state.reviewsHaveNextPage,
              serviceId: serviceId,
            );
          },
        ),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({
    required this.profile,
    required this.reviews,
    required this.reviewsHaveNextPage,
    this.serviceId,
  });
  final ProviderProfileEntity profile;
  final List<ProviderReviewEntity> reviews;
  final bool reviewsHaveNextPage;
  final String? serviceId;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<ProviderProfileCubit>().execute(
        ProviderProfileCommand(ProviderProfileAction.load, profile.id),
      ),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.all(20.r),
        children: <Widget>[
          CircleAvatar(
            radius: 48.r,
            backgroundImage: profile.avatarUrl == null
                ? null
                : NetworkImage(profile.avatarUrl!),
            child: profile.avatarUrl == null
                ? const Icon(Icons.person_rounded)
                : null,
          ),
          SizedBox(height: 12.h),
          Text(
            profile.fullName,
            textAlign: TextAlign.center,
            style: TextStyles.bold24(color: colors.onboardingHeadline),
          ),
          if (profile.jobTitle != null)
            Text(profile.jobTitle!, textAlign: TextAlign.center),
          Text(
            profile.isOnline
                ? 'provider_profile_online_now'.tr
                : 'chat_status_offline'.tr,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            profile.rating == null
                ? 'customer_not_enough_ratings'.tr
                : '${profile.rating!.toStringAsFixed(1)} ★ (${profile.reviewCount})',
            textAlign: TextAlign.center,
            style: TextStyles.bold18(color: colors.review),
          ),
          SizedBox(height: 16.h),
          Text(
            profile.localizedDescription(isArabic),
            style: TextStyles.regular16(color: colors.lightTextColor),
          ),
          SizedBox(height: 16.h),
          Text(
            '${'provider_profile_jobs_done'.tr}: ${profile.numberOfJobsDone}',
          ),
          if (profile.experienceYears != null)
            Text(
              '${'provider_profile_experience'.tr}: ${profile.experienceYears}',
            ),
          SizedBox(height: 20.h),
          if (profile.portfolioImages.isNotEmpty) ...<Widget>[
            Text(
              'provider_profile_portfolio_title'.tr,
              style: TextStyles.bold22(color: colors.onboardingHeadline),
            ),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: profile.portfolioImages
                  .map(
                    (imageUrl) => Image.network(
                      imageUrl,
                      width: 92.r,
                      height: 92.r,
                      fit: BoxFit.cover,
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 20.h),
          ],
          if (profile.certificates.isNotEmpty) ...<Widget>[
            Text(
              'provider_profile_certificates_title'.tr,
              style: TextStyles.bold22(color: colors.onboardingHeadline),
            ),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: profile.certificates
                  .map(
                    (certificate) => Image.network(
                      certificate.imageUrl,
                      width: 92.r,
                      height: 92.r,
                      fit: BoxFit.cover,
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 20.h),
          ],
          Text(
            'provider_profile_reviews_title'.tr,
            style: TextStyles.bold22(color: colors.onboardingHeadline),
          ),
          if (reviews.isEmpty)
            Text(
              'noDataFound'.tr,
              textAlign: TextAlign.center,
              style: TextStyles.medium16(color: colors.lightTextColor),
            )
          else
            ...reviews.map(
              (review) => ListTile(
                contentPadding: EdgeInsetsDirectional.zero,
                title: Text(review.customerName),
                subtitle: Text(review.comment ?? ''),
                trailing: Text('${review.rating.toStringAsFixed(1)} ★'),
              ),
            ),
          if (reviewsHaveNextPage)
            TextButton(
              onPressed: () => context.read<ProviderProfileCubit>().execute(
                ProviderProfileCommand(
                  ProviderProfileAction.loadMoreReviews,
                  profile.id,
                ),
              ),
              child: Text('load_more'.tr),
            ),
          if (serviceId != null)
            FilledButton(
              onPressed: () => context.pushNamed(
                Routes.confirmLocationRoute,
                extra: BookingDraft(
                  serviceId: serviceId!,
                  providerId: profile.id,
                  bookingType: 0,
                ),
              ),
              child: Text('provider_profile_book_now'.tr),
            ),
        ],
      ),
    );
  }
}
