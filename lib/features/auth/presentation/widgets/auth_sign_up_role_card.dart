import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/injection_container.dart';

class AuthSignUpRoleCard extends StatelessWidget {
  const AuthSignUpRoleCard({
    super.key,
    required this.titleKey,
    required this.subtitleKey,
    required this.leadIcon,
    required this.leadIconColor,
    required this.selected,
    required this.onTap,
  });

  final String titleKey;
  final String subtitleKey;
  final IconData leadIcon;
  final Color leadIconColor;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsetsDirectional.all(12.w),
            decoration: BoxDecoration(
              color: selected
                  ? colors.authSignUpSelectedSurface
                  : colors.authSignUpUnselectedSurface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: selected
                    ? colors.authBrandRed
                    : colors.onboardingBorderNeutral,
                width: selected ? 2 : 1,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: colors.whiteColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        leadIcon,
                        size: 20.r,
                        color: leadIconColor,
                      ),
                    ),
                    Gaps.vGap12,
                    Text(
                      titleKey.tr,
                      style: TextStyles.bold15(color: colors.onboardingTextStrong),
                    ),
                    Gaps.vGap4,
                    Text(
                      subtitleKey.tr,
                      style: TextStyles.regular12(color: colors.onboardingBody),
                    ),
                  ],
                ),
                if (selected)
                  PositionedDirectional(
                    top: 0,
                    end: 0,
                    child: Container(
                      width: 22.r,
                      height: 22.r,
                      decoration: BoxDecoration(
                        color: colors.authBrandRed,
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: colors.shadowCardLight,
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 15.r,
                        color: colors.whiteColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
