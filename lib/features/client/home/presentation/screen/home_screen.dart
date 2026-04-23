import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/widgets/gaps.dart';
import '/features/client/home/presentation/widgets/home_header.dart';
import '/features/client/home/presentation/widgets/home_popular_services_section.dart';
import '/features/client/home/presentation/widgets/home_service_categories_row.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const HomeHeader(),
                    Padding(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 16.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const HomeServiceCategoriesRow(),
                          Gaps.vGap20,
                          const HomePopularServicesSection(),
                          Gaps.vGap16,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
