import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_centered_header_bar.dart';
import '/features/client/customer/domain/entities/customer_entities.dart';
import '/features/client/customer/presentation/cubit/catalog_cubit.dart';
import '/features/client/customer/presentation/widgets/customer_state_widgets.dart';
import '/injection_container.dart';

class CategoryServicesScreen extends StatelessWidget {
  const CategoryServicesScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  final String categoryId;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CatalogCubit>(
      create: (_) =>
          ServiceLocator.instance()
            ..execute(CatalogCommand.services(categoryId: categoryId)),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              AppCenteredHeaderBar(title: categoryName, onBack: context.pop),
              Expanded(
                child: BlocBuilder<CatalogCubit, CatalogState>(
                  builder: (_, state) {
                    if (state is CatalogFailure) {
                      return CustomerErrorView(state.message);
                    }
                    if (state is! ServicesSuccess) {
                      return const CustomerLoadingView();
                    }
                    return ListView.separated(
                      padding: EdgeInsetsDirectional.all(16.r),
                      itemCount: state.items.length,
                      separatorBuilder: (_, _) => SizedBox(height: 12.h),
                      itemBuilder: (_, index) =>
                          _ServiceTile(service: state.items[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.service});
  final ServiceEntity service;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () =>
            context.pushNamed(Routes.serviceDetailsRoute, extra: service.id),
        leading: const Icon(Icons.home_repair_service_rounded),
        title: Text(
          service.localizedName(isArabic),
          style: TextStyles.bold18(color: colors.onboardingHeadline),
        ),
        subtitle: Text(
          service.localizedDescription(isArabic),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: service.fixedPrice == null
            ? null
            : Text('${service.fixedPrice} ${service.currency}'),
      ),
    );
  }
}
