// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/app_colors.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_shimmer.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/my_default_button.dart';
import '../../domain/entities/governments_entity.dart';
import '../cubit/country_selection_cubit/country_selection_cubit.dart';
import '../cubit/country_selection_cubit/country_selection_state.dart';

import '../cubit/register_form_cubit/register_form_cubit.dart';
import '../widgets/auth_app_bar.dart';

import '/injection_container.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _GovernmentsDropdownShimmer extends StatelessWidget {
  const _GovernmentsDropdownShimmer();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20.h,
            width: 140.w,
            decoration: BoxDecoration(
              color: MyColors.whiteColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          Gaps.vGap12,
          Container(
            height: 55.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: MyColors.whiteColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ],
      ),
    );
  }
}

class _GovernmentsDropdownError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _GovernmentsDropdownError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message.isNotEmpty ? message : 'something_went_wrong'.tr,
          style: TextStyles.medium16(color: MyColors.errorColor),
        ),
        Gaps.vGap12,
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: MyDefaultButton(
            btnText: 'retry'.tr,
            onPressed: onRetry,
            width: 140.w,
            height: 45.h,
            color: MyColors.main,
            textColor: MyColors.whiteColor,
            borderColor: MyColors.main,
            borderRadius: 12,
            textStyle: TextStyles.bold16(color: MyColors.whiteColor),
          ),
        ),
      ],
    );
  }
}

class _ActivityTypesDropdownShimmer extends StatelessWidget {
  const _ActivityTypesDropdownShimmer();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20.h,
            width: 140.w,
            decoration: BoxDecoration(
              color: MyColors.whiteColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          Gaps.vGap12,
          Container(
            height: 55.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: MyColors.whiteColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityTypesDropdownError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ActivityTypesDropdownError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message.isNotEmpty ? message : 'something_went_wrong'.tr,
          style: TextStyles.medium16(color: MyColors.errorColor),
        ),
        Gaps.vGap12,
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: MyDefaultButton(
            btnText: 'retry'.tr,
            onPressed: onRetry,
            width: 140.w,
            height: 45.h,
            color: MyColors.main,
            textColor: MyColors.whiteColor,
            borderColor: MyColors.main,
            borderRadius: 12,
            textStyle: TextStyles.bold16(color: MyColors.whiteColor),
          ),
        ),
      ],
    );
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _commercialRegistrationController;
  late final TextEditingController _taxNumberController;

  late final FocusNode _nameFocus;
  late final FocusNode _phoneFocus;
  late final FocusNode _emailFocus;
  late final FocusNode _addressFocus;
  late final FocusNode _passwordFocus;
  late final FocusNode _confirmPasswordFocus;
  late final FocusNode _commercialRegistrationFocus;
  late final FocusNode _taxNumberFocus;

  int? _lastRequestedCountryId;
  final bool _shouldShowCongratulationsDialog = false;
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _initializeControllers();
    _initializeFocusNodes();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _setupControllerListeners();
    });
  }

  void _setupControllerListeners() {
    _commercialRegistrationController.addListener(() {
      if (!mounted) return;
      context.read<RegisterFormCubit>().updateCommercialRegistration(
        _commercialRegistrationController.text.trim().isEmpty
            ? null
            : _commercialRegistrationController.text.trim(),
      );
    });
    _taxNumberController.addListener(() {
      if (!mounted) return;
      context.read<RegisterFormCubit>().updateTaxNumber(
        _taxNumberController.text.trim().isEmpty
            ? null
            : _taxNumberController.text.trim(),
      );
    });
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _commercialRegistrationController = TextEditingController();
    _taxNumberController = TextEditingController();
  }

  void _initializeFocusNodes() {
    _nameFocus = FocusNode();
    _phoneFocus = FocusNode();
    _emailFocus = FocusNode();
    _addressFocus = FocusNode();
    _passwordFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();
    _commercialRegistrationFocus = FocusNode();
    _taxNumberFocus = FocusNode();
  }

  @override
  void dispose() {
    _disposeControllers();
    _disposeFocusNodes();
    super.dispose();
  }

  void _disposeControllers() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _commercialRegistrationController.dispose();
    _taxNumberController.dispose();
  }

  void _disposeFocusNodes() {
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _addressFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _commercialRegistrationFocus.dispose();
    _taxNumberFocus.dispose();
  }

  void _unfocusAll() {
    _nameFocus.unfocus();
    _phoneFocus.unfocus();
    _emailFocus.unfocus();
    _addressFocus.unfocus();
    _passwordFocus.unfocus();
    _confirmPasswordFocus.unfocus();
    _commercialRegistrationFocus.unfocus();
    _taxNumberFocus.unfocus();
  }

  void _requestGovernorates({bool force = false}) {
    final selectedCountry = context
        .read<CountrySelectionCubit>()
        .selectedCountry;
    final int? countryId = selectedCountry?.id;
    if (countryId == null) {
      return;
    }
    if (!force && _lastRequestedCountryId == countryId) {
      return;
    }
    _lastRequestedCountryId = countryId;
  }

  GovernmentsEntity? _getInitialGovernment(
    List<GovernmentsEntity> governments,
    int? governmentId,
  ) {
    if (governmentId != null) {
      try {
        return governments.firstWhere((gov) => gov.id == governmentId);
      } catch (e) {
        return governments.isNotEmpty ? governments.first : null;
      }
    }
    return governments.isNotEmpty ? governments.first : null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CountrySelectionCubit, CountrySelectionState>(
      listener: (context, state) {
        if (state is CountrySelected) {
          _requestGovernorates(force: true);
        }
      },
      child: GestureDetector(
        onTap: _unfocusAll,
        child: Scaffold(
          backgroundColor: colors.whiteColor,
          appBar: AuthAppBar(showBackButton: true, text: 'create_account'.tr),
          body: Column(),
        ),
      ),
    );
  }
}
