import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/features/provider/chats/presentation/screen/provider_chats_screen.dart';
import 'package:khedma/features/provider/home/presentation/cubit/provider_navigation_cubit/provider_navigation_cubit.dart';
import 'package:khedma/features/provider/home/presentation/screen/provider_home_screen.dart';
import 'package:khedma/features/provider/jobs/presentation/screen/provider_jobs_screen.dart';
import 'package:khedma/features/provider/home/presentation/widgets/provider_bottom_nav_bar.dart';
import 'package:khedma/features/provider/profile/presentation/screen/provider_profile_screen.dart';
import 'package:khedma/injection_container.dart';

class ProviderMainNavigationScreen extends StatelessWidget {
  const ProviderMainNavigationScreen({super.key});

  static const List<Widget> _bodies = <Widget>[
    ProviderHomeScreen(),
    ProviderJobsScreen(),
    ProviderChatsScreen(),
    ProviderProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderNavigationCubit, ProviderNavigationState>(
      builder: (BuildContext context, ProviderNavigationState state) {
        return Scaffold(
          backgroundColor: colors.backGround,
          body: IndexedStack(index: state.current.index, children: _bodies),
          bottomNavigationBar: ProviderBottomNavBar(
            current: state.current,
            onTap: (ProviderNavItem i) {
              context.read<ProviderNavigationCubit>().changeIndex(i);
            },
          ),
        );
      },
    );
  }
}
