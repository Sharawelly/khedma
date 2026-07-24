import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_centered_header_bar.dart';
import '/core/widgets/no_data_found.dart';
import '/features/client/customer/domain/entities/customer_entities.dart';
import '/features/client/customer/presentation/cubit/catalog_cubit.dart';
import '/features/client/customer/presentation/widgets/customer_state_widgets.dart';
import '/injection_container.dart';

class CategoryServicesScreen extends StatefulWidget {
  const CategoryServicesScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  final String categoryId;
  final String categoryName;

  @override
  State<CategoryServicesScreen> createState() => _CategoryServicesScreenState();
}

class _CategoryServicesScreenState extends State<CategoryServicesScreen> {
  late final CatalogCubit cubit = ServiceLocator.instance();
  Timer? searchDebounce;
  String search = '';

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    searchDebounce?.cancel();
    cubit.close();
    super.dispose();
  }

  Future<void> _refresh() => cubit.execute(
    CatalogCommand.services(categoryId: widget.categoryId, search: search),
  );

  void _search(String value) {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 400), () {
      search = value.trim();
      _refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CatalogCubit>.value(
      value: cubit,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              AppCenteredHeaderBar(
                title: widget.categoryName,
                onBack: context.pop,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 8.h),
                child: SearchBar(
                  hintText: 'customer_search_services'.tr,
                  leading: const Icon(Icons.search_rounded),
                  onChanged: _search,
                ),
              ),
              Expanded(
                child: BlocBuilder<CatalogCubit, CatalogState>(
                  builder: (context, state) {
                    if (state is CatalogFailure) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CustomerErrorView(state.message),
                            TextButton(
                              onPressed: _refresh,
                              child: Text('retry'.tr),
                            ),
                          ],
                        ),
                      );
                    }
                    if (state is! ServicesSuccess) {
                      return const CustomerLoadingView();
                    }
                    if (state.items.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: _refresh,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: 400.h,
                            child: const NoDataFound(),
                          ),
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsetsDirectional.all(16.r),
                        itemCount:
                            state.items.length + (state.hasNextPage ? 1 : 0),
                        separatorBuilder: (_, _) => SizedBox(height: 12.h),
                        itemBuilder: (_, index) {
                          if (index == state.items.length) {
                            return TextButton(
                              onPressed: () => cubit.execute(
                                const CatalogCommand.moreServices(),
                              ),
                              child: Text('load_more'.tr),
                            );
                          }
                          return _ServiceTile(service: state.items[index]);
                        },
                      ),
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
