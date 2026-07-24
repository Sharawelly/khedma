import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/my_default_button.dart';
import '/features/client/customer/domain/entities/customer_entities.dart';
import '/features/client/customer/domain/usecases/params/customer_params.dart';
import '/features/client/customer/presentation/cubit/catalog_cubit.dart';
import '/features/client/customer/presentation/widgets/customer_state_widgets.dart';
import '/injection_container.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key, required this.serviceId});
  final String serviceId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CatalogCubit>(
      create: (_) =>
          ServiceLocator.instance()..execute(CatalogCommand.service(serviceId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('customer_service_details'.tr),
          leading: BackButton(onPressed: context.pop),
        ),
        body: BlocBuilder<CatalogCubit, CatalogState>(
          builder: (context, state) {
            if (state is CatalogFailure) {
              return CustomerErrorView(state.message);
            }
            if (state is! ServiceSuccess) {
              return const CustomerLoadingView();
            }
            return _ServiceBody(service: state.item);
          },
        ),
      ),
    );
  }
}

class _ServiceBody extends StatelessWidget {
  const _ServiceBody({required this.service});
  final ServiceEntity service;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsetsDirectional.all(20.r),
      children: <Widget>[
        if (service.imageUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: Image.network(
              service.imageUrl!,
              height: 230.h,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => SizedBox(height: 230.h),
            ),
          ),
        if (service.imageUrls.isNotEmpty) ...<Widget>[
          SizedBox(height: 10.h),
          SizedBox(
            height: 76.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: service.imageUrls.length,
              separatorBuilder: (_, _) => SizedBox(width: 8.w),
              itemBuilder: (_, index) => ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.network(
                  service.imageUrls[index],
                  width: 76.r,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
        SizedBox(height: 16.h),
        Text(
          service.localizedName(isArabic),
          style: TextStyles.bold32(color: colors.onboardingHeadline),
        ),
        SizedBox(height: 8.h),
        Text(
          service.localizedDescription(isArabic),
          style: TextStyles.regular16(color: colors.lightTextColor),
        ),
        SizedBox(height: 16.h),
        Text(
          '${service.rating.toStringAsFixed(1)} ★ (${service.reviewCount})',
          style: TextStyles.bold18(color: colors.review),
        ),
        SizedBox(height: 8.h),
        if (service.total != null)
          Text(
            '${service.total} ${service.currency}',
            style: TextStyles.bold24(color: colors.errorColor),
          ),
        if (service.availableProvidersCount != null)
          Text(
            '${'customer_available_providers'.tr}: ${service.availableProvidersCount}',
          ),
        SizedBox(height: 20.h),
        _ServiceProviders(service: service),
        SizedBox(height: 28.h),
        MyDefaultButton(
          btnText: 'home_service_book_now',
          onPressed: () => context.pushNamed(
            Routes.confirmLocationRoute,
            extra: BookingDraft(serviceId: service.id, bookingType: 0),
          ),
          color: colors.errorColor,
          borderColor: colors.errorColor,
        ),
      ],
    );
  }
}

class _ServiceProviders extends StatelessWidget {
  const _ServiceProviders({required this.service});
  final ServiceEntity service;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CatalogCubit>(
      create: (_) => ServiceLocator.instance()
        ..execute(
          CatalogCommand.providers(
            categoryId: service.categoryId,
            nearby: false,
          ),
        ),
      child: BlocBuilder<CatalogCubit, CatalogState>(
        builder: (_, state) {
          if (state is CatalogFailure) {
            return CustomerErrorView(state.message);
          }
          if (state is! ProvidersSuccess) {
            return SizedBox(height: 100.h, child: const CustomerLoadingView());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'customer_choose_provider'.tr,
                style: TextStyles.bold22(color: colors.onboardingHeadline),
              ),
              ...state.items.map(
                (provider) => ListTile(
                  contentPadding: EdgeInsetsDirectional.zero,
                  onTap: () => context.pushNamed(
                    Routes.providerProfileRoute,
                    extra: <String, String>{
                      'providerId': provider.id,
                      'serviceId': service.id,
                    },
                  ),
                  leading: const CircleAvatar(
                    child: Icon(Icons.person_rounded),
                  ),
                  title: Text(provider.name),
                  subtitle: Text(provider.jobTitle ?? ''),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
