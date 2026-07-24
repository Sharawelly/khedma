import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/no_data_found.dart';
import '/features/client/customer/domain/entities/customer_entities.dart';
import '/features/client/customer/presentation/cubit/catalog_cubit.dart';
import '/features/client/customer/presentation/widgets/customer_state_widgets.dart';
import '/injection_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final CatalogCubit categoriesCubit = ServiceLocator.instance()
    ..execute(const CatalogCommand.categories());
  late final CatalogCubit providersCubit = ServiceLocator.instance()
    ..execute(const CatalogCommand.providers());
  Timer? searchDebounce;
  String providerSearch = '';

  @override
  void dispose() {
    searchDebounce?.cancel();
    categoriesCubit.close();
    providersCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait<void>(<Future<void>>[
              categoriesCubit.execute(const CatalogCommand.categories()),
              providersCubit.execute(
                CatalogCommand.providers(search: providerSearch),
              ),
            ]);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsetsDirectional.all(16.r),
            children: <Widget>[
              Text(
                'customer_catalogue'.tr,
                style: TextStyles.bold32(color: colors.onboardingHeadline),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                height: 128.h,
                child: BlocBuilder<CatalogCubit, CatalogState>(
                  bloc: categoriesCubit,
                  builder: (_, state) {
                    if (state is CatalogFailure) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CustomerErrorView(state.message),
                          TextButton(
                            onPressed: () => categoriesCubit.execute(
                              const CatalogCommand.categories(),
                            ),
                            child: Text('retry'.tr),
                          ),
                        ],
                      );
                    }
                    if (state is! CategoriesSuccess) {
                      return const CustomerLoadingView();
                    }
                    if (state.items.isEmpty) {
                      return const NoDataFound();
                    }
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.items.length,
                      separatorBuilder: (_, _) => SizedBox(width: 10.w),
                      itemBuilder: (_, index) {
                        final category = state.items[index];
                        return _CategoryCard(
                          category: category,
                          onTap: () => context.pushNamed(
                            Routes.categoryServicesRoute,
                            pathParameters: <String, String>{
                              'categoryKey': category.id,
                            },
                            extra: category.localizedName(isArabic),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 24.h),
              SearchBar(
                hintText: 'customer_search_providers'.tr,
                leading: const Icon(Icons.search_rounded),
                onChanged: (value) {
                  searchDebounce?.cancel();
                  searchDebounce = Timer(const Duration(milliseconds: 400), () {
                    providerSearch = value.trim();
                    providersCubit.execute(
                      CatalogCommand.providers(search: providerSearch),
                    );
                  });
                },
              ),
              SizedBox(height: 16.h),
              BlocBuilder<CatalogCubit, CatalogState>(
                bloc: providersCubit,
                builder: (_, state) {
                  final nearby = state is ProvidersSuccess && state.nearby;
                  return Text(
                    nearby
                        ? 'customer_nearby_providers'.tr
                        : 'customer_all_providers'.tr,
                    style: TextStyles.bold22(color: colors.onboardingHeadline),
                  );
                },
              ),
              SizedBox(height: 12.h),
              BlocBuilder<CatalogCubit, CatalogState>(
                bloc: providersCubit,
                builder: (_, state) {
                  if (state is CatalogFailure) {
                    return Column(
                      children: <Widget>[
                        CustomerErrorView(state.message),
                        TextButton(
                          onPressed: () => providersCubit.execute(
                            CatalogCommand.providers(search: providerSearch),
                          ),
                          child: Text('retry'.tr),
                        ),
                      ],
                    );
                  }
                  if (state is! ProvidersSuccess) {
                    return SizedBox(
                      height: 300.h,
                      child: const CustomerLoadingView(),
                    );
                  }
                  if (state.items.isEmpty) {
                    return SizedBox(height: 260.h, child: const NoDataFound());
                  }
                  return Column(
                    children: <Widget>[
                      ...state.items.map(
                        (provider) => Card(
                          child: ListTile(
                            onTap: () => context.pushNamed(
                              Routes.providerProfileRoute,
                              extra: provider.id,
                            ),
                            leading: const CircleAvatar(
                              child: Icon(Icons.person_rounded),
                            ),
                            title: Text(provider.name),
                            subtitle: Text(
                              provider.distanceKm == null
                                  ? provider.jobTitle ?? ''
                                  : '${provider.distanceKm!.toStringAsFixed(1)} ${'customer_km'.tr}',
                            ),
                            trailing: provider.rating == null
                                ? Text('customer_not_enough_ratings'.tr)
                                : Text(
                                    '${provider.rating!.toStringAsFixed(1)} ★',
                                  ),
                          ),
                        ),
                      ),
                      if (state.hasNextPage)
                        TextButton(
                          onPressed: () => providersCubit.execute(
                            const CatalogCommand.moreProviders(),
                          ),
                          child: Text('load_more'.tr),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.onTap});
  final CategoryEntity category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 130.w,
        padding: EdgeInsetsDirectional.all(12.r),
        decoration: BoxDecoration(
          color: colors.whiteColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: colors.onboardingBorderNeutral),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.home_repair_service_rounded, color: colors.errorColor),
            SizedBox(height: 8.h),
            Text(
              category.localizedName(isArabic),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.bold16(color: colors.onboardingHeadline),
            ),
            Text(
              '${category.serviceCount}',
              style: TextStyles.regular14(color: colors.lightTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
