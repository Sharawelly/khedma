import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/features/client/customer/presentation/cubit/favorites_cubit.dart';
import '/features/client/customer/presentation/widgets/customer_state_widgets.dart';
import '/injection_container.dart';

class ProfileTopProvidersCard extends StatelessWidget {
  const ProfileTopProvidersCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoritesCubit>(
      create: (_) => ServiceLocator.instance()..load(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.all(14.r),
        decoration: BoxDecoration(
          color: colors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colors.onboardingBorderNeutral),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'profile_favorite_providers'.tr,
              style: TextStyles.bold18(color: colors.onboardingHeadline),
            ),
            SizedBox(height: 10.h),
            BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (_, state) {
                if (state is FavoritesFailure) {
                  return CustomerErrorView(state.message);
                }
                if (state is! FavoritesSuccess) {
                  return const LinearProgressIndicator();
                }
                if (state.providers.isEmpty) {
                  return Text('customer_no_favorites'.tr);
                }
                return Wrap(
                  spacing: 8.w,
                  children: state.providers
                      .map(
                        (provider) => InkWell(
                          onTap: () => context.pushNamed(
                            Routes.providerProfileRoute,
                            extra: provider.id,
                          ),
                          child: CircleAvatar(
                            radius: 24.r,
                            backgroundImage: provider.photo == null
                                ? null
                                : NetworkImage(provider.photo!),
                            child: provider.photo == null
                                ? const Icon(Icons.person_rounded)
                                : null,
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
