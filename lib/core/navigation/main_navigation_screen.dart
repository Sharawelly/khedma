import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/navigation/cubit/navigation_cubit.dart';
import '/core/widgets/app_bottom_nav_bar.dart';
import '/features/client/bookings/presentation/screens/bookings_screen.dart';
import '/features/client/chats/presentation/screen/chats_screen.dart';
import '/features/client/home/presentation/screen/home_screen.dart';
import '/features/client/profile/presentation/screen/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    BookingsScreen(),
    ChatsScreen(),
    ProfileScreen(),
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
