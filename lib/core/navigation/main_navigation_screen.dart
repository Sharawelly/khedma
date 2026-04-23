import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/config/locale/app_localizations.dart';
import '/core/navigation/cubit/navigation_cubit.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_bottom_nav_bar.dart';
import '/features/home/presentation/screen/home_screen.dart';
import '/injection_container.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    _NavigationPlaceholder(titleKey: 'home_tab_bookings'),
    _NavigationPlaceholder(titleKey: 'home_tab_chats'),
    _NavigationPlaceholder(titleKey: 'home_tab_profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.currentIndex.index,
            children: _screens,
          ),
          bottomNavigationBar: AppBottomNavBar(
            currentIndex: state.currentIndex,
            onTap: context.read<NavigationCubit>().changeNavigationIndex,
          ),
        );
      },
    );
  }
}

class _NavigationPlaceholder extends StatelessWidget {
  const _NavigationPlaceholder({required this.titleKey});

  final String titleKey;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        titleKey.tr,
        style: TextStyles.bold24(color: colors.onboardingHeadline),
      ),
    );
  }
}
