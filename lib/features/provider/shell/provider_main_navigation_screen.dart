import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/features/provider/presentation/cubit/provider_navigation_cubit/provider_navigation_cubit.dart';
import 'package:khedma/features/provider/presentation/screen/provider_home_screen.dart';
import 'package:khedma/features/provider/presentation/screen/provider_stub_tab_screen.dart';
import 'package:khedma/features/provider/presentation/widgets/provider_bottom_nav_bar.dart';
import 'package:khedma/injection_container.dart';

class ProviderMainNavigationScreen extends StatelessWidget {
  const ProviderMainNavigationScreen({super.key});

  static const List<Widget> _bodies = <Widget>[
    ProviderHomeScreen(),
    ProviderStubTabScreen(messageKey: 'provider_stub_schedule'),
    ProviderStubTabScreen(messageKey: 'provider_stub_wallet'),
    ProviderStubTabScreen(messageKey: 'provider_stub_profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderNavigationCubit, ProviderNavigationState>(
      builder: (BuildContext context, ProviderNavigationState state) {
        return Scaffold(
          backgroundColor: colors.backGround,
          body: SafeArea(
            child: IndexedStack(
              index: state.current.index,
              children: _bodies,
            ),
          ),
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
