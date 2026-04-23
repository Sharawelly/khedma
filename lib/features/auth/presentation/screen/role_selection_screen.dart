import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/config/routes/app_routes.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/core/widgets/my_default_button.dart';
import 'package:khedma/features/auth/presentation/cubit/role_selection_cubit/role_selection_cubit.dart';
import 'package:khedma/features/auth/presentation/widgets/auth_sign_up_brand_header.dart';
import 'package:khedma/features/auth/presentation/widgets/auth_sign_up_role_card.dart';
import 'package:khedma/features/auth/presentation/widgets/auth_sign_up_sign_in_footer.dart';
import 'package:khedma/features/auth/presentation/widgets/auth_sign_up_title_section.dart';
import 'package:khedma/injection_container.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RoleSelectionCubit>(
      create: (_) => ServiceLocator.instance<RoleSelectionCubit>(),
      child: const _RoleSelectionView(),
    );
  }
}

class _RoleSelectionView extends StatelessWidget {
  const _RoleSelectionView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.topCenter,
            end: AlignmentDirectional.bottomCenter,
            colors: <Color>[
              colors.backGround,
              colors.backGround,
              colors.authSignUpBackgroundWash,
            ],
            stops: <double>[0, 0.5, 1],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<RoleSelectionCubit, RoleSelectionState>(
            builder: (BuildContext context, RoleSelectionState state) {
              final RoleSelectionCubit cubit = context.read<RoleSelectionCubit>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                      child: Column(
                        children: <Widget>[
                          Gaps.vGap24,
                          const AuthSignUpBrandHeader(),
                          Gaps.vGap24,
                          Gaps.vGap4,
                          const AuthSignUpTitleSection(),
                          Gaps.vGap32,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AuthSignUpRoleCard(
                                titleKey: 'auth_sign_up_role_need_title',
                                subtitleKey: 'auth_sign_up_role_need_subtitle',
                                leadIcon: Icons.person_rounded,
                                leadIconColor: colors.authBrandRed,
                                selected: state.selectedRole == 'need_service',
                                onTap: () => cubit.selectRole('need_service'),
                              ),
                              Gaps.hGap12,
                              AuthSignUpRoleCard(
                                titleKey: 'auth_sign_up_role_provide_title',
                                subtitleKey: 'auth_sign_up_role_provide_subtitle',
                                leadIcon: Icons.handyman_rounded,
                                leadIconColor: colors.secondary,
                                selected: state.selectedRole == 'provide_services',
                                onTap: () => cubit.selectRole('provide_services'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28.r),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: colors.shadowCardMedium,
                            blurRadius: 12,
                            offset: Offset(0, 6.h),
                          ),
                        ],
                      ),
                      child: MyDefaultButton(
                        btnText: 'auth_sign_up_continue'.tr,
                        localeText: true,
                        onPressed: () {
                          if (!state.hasSelection) {
                            return;
                          }
                          if (state.selectedRole == 'need_service') {
                            context.go(Routes.appShellRoute);
                            return;
                          }
                          context.push(
                            Routes.createAccountRoute,
                            extra: <String, String>{
                              'registration_role': state.selectedRole,
                            },
                          );
                        },
                        color: colors.authBrandRed,
                        textColor: colors.whiteColor,
                        borderColor: colors.authBrandRed,
                        borderRadius: 28,
                        height: 56,
                        textStyle: TextStyles.bold16(color: colors.whiteColor),
                      ),
                    ),
                  ),
                  Gaps.vGap16,
                  Padding(
                    padding: EdgeInsetsDirectional.only(bottom: 12.h),
                    child: const AuthSignUpSignInFooter(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
