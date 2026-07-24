import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_shimmer.dart';
import '/features/provider/presentation/cubit/provider_services_cubit.dart';
import '/injection_container.dart';

/// Declared here rather than imported: the equivalent getter lives in the
/// customer widgets, and the provider feature should not depend on those.
bool get _isArabic => !appLocalizations.isEnLocale;

/// The services this provider offers, and the entry point to change them.
///
/// Dispatch only matches a provider against services they offer, so an empty
/// list here is called out rather than shown as a neutral blank.
class ProviderServicesSection extends StatelessWidget {
  const ProviderServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProviderServicesCubit>(
      create: (_) => ServiceLocator.instance<ProviderServicesCubit>()..load(),
      child: const _ServicesCard(),
    );
  }
}

class _ServicesCard extends StatelessWidget {
  const _ServicesCard();

  Future<void> _edit(BuildContext context) async {
    final cubit = context.read<ProviderServicesCubit>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(20.r),
          topEnd: Radius.circular(20.r),
        ),
      ),
      // The existing cubit is handed to the sheet so edits land on the same
      // instance the card is listening to.
      builder: (_) => BlocProvider<ProviderServicesCubit>.value(
        value: cubit,
        child: const _ServicesEditor(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(14.r),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'provider_my_services'.tr,
                  style: TextStyles.bold18(color: colors.onboardingHeadline),
                ),
              ),
              TextButton(
                onPressed: () => _edit(context),
                child: Text('provider_edit_services'.tr),
              ),
            ],
          ),
          BlocBuilder<ProviderServicesCubit, ProviderServicesState>(
            builder: (context, state) {
              if (state is ProviderServicesFailure) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SelectableText.rich(
                      TextSpan(
                        text: state.message,
                        style: TextStyle(color: colors.errorColor),
                      ),
                    ),
                    TextButton(
                      onPressed: context.read<ProviderServicesCubit>().load,
                      child: Text('retry'.tr),
                    ),
                  ],
                );
              }
              if (state is! ProviderServicesLoaded) {
                return AppShimmer(
                  child: Container(
                    height: 48.h,
                    width: double.infinity,
                    color: colors.lightBackGroundColor,
                  ),
                );
              }
              final offered = state.offered;
              if (offered.isEmpty) {
                return Text(
                  'provider_no_services_warning'.tr,
                  style: TextStyles.regular14(color: colors.errorColor),
                );
              }
              return Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: offered
                    .map(
                      (service) => Chip(
                        label: Text(service.localizedName(_isArabic)),
                        backgroundColor: colors.lightBackGroundColor,
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ServicesEditor extends StatelessWidget {
  const _ServicesEditor();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProviderServicesCubit, ProviderServicesState>(
      listener: (context, state) {
        if (state is ProviderServicesSaved) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsetsDirectional.all(16.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'provider_edit_services'.tr,
                  style: TextStyles.bold20(color: colors.onboardingHeadline),
                ),
                SizedBox(height: 4.h),
                Text(
                  'provider_services_hint'.tr,
                  style: TextStyles.regular14(color: colors.onboardingCaption),
                ),
                SizedBox(height: 12.h),
                Flexible(child: _Body(state: state)),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: state is ProviderServicesLoaded && state.dirty
                        ? context.read<ProviderServicesCubit>().save
                        : null,
                    child: Text('save'.tr),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});
  final ProviderServicesState state;

  @override
  Widget build(BuildContext context) {
    if (state is ProviderServicesFailure) {
      return SelectableText.rich(
        TextSpan(
          text: (state as ProviderServicesFailure).message,
          style: TextStyle(color: colors.errorColor),
        ),
      );
    }
    if (state is! ProviderServicesLoaded) {
      return SizedBox(
        height: 120.h,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    final services = (state as ProviderServicesLoaded).services;
    if (services.isEmpty) {
      return Text('provider_no_catalogue_services'.tr);
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        // The list arrives ordered by category, so a header is emitted only
        // when the category changes rather than grouping the list again here.
        final showHeader =
            index == 0 ||
            services[index - 1].categoryNameEn != service.categoryNameEn;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (showHeader)
              Padding(
                padding: EdgeInsetsDirectional.only(top: 8.h, bottom: 4.h),
                child: Text(
                  service.localizedCategory(_isArabic),
                  style: TextStyles.bold16(color: colors.onboardingTextStrong),
                ),
              ),
            CheckboxListTile(
              value: service.isOffered,
              onChanged: (_) => context.read<ProviderServicesCubit>().toggle(
                service.serviceId,
              ),
              title: Text(service.localizedName(_isArabic)),
              subtitle: service.fixedPrice == null
                  ? null
                  : Text(service.fixedPrice!.toStringAsFixed(2)),
              contentPadding: EdgeInsetsDirectional.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        );
      },
    );
  }
}
