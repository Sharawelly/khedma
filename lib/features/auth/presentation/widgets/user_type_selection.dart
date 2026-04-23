import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '../cubit/register_form_cubit/register_form_cubit.dart';
import '../cubit/register_form_cubit/register_form_state.dart';
import '/injection_container.dart';

class UserTypeSelection extends StatelessWidget {
  const UserTypeSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterFormCubit, RegisterFormState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildUserTypeOption(
                context,
                'individual',
                'individual'.tr,
                state.selectedUserType,
              ),

              Gaps.hGap10,
              _buildUserTypeOption(
                context,
                'organization',
                '${'company_type'.tr} / ${'institution'.tr}',
                state.selectedUserType,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserTypeOption(
    BuildContext context,
    String value,
    String label,
    String selectedUserType,
  ) {
    final isSelected = selectedUserType == value;
    return GestureDetector(
      onTap: () {
        context.read<RegisterFormCubit>().selectUserType(value);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 25.w,
            height: 25.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? colors.main : const Color(0xFFD9D9D9),
            ),
          ),
          SizedBox(width: 7.w),
          Text(label, style: TextStyles.bold20(color: Colors.black)),
        ],
      ),
    );
  }
}
