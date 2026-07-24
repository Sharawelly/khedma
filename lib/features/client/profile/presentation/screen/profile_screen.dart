import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/cached_network_image_with_fallback.dart';
import '/core/widgets/app_shimmer.dart';
import '/core/widgets/gaps.dart';
import '/features/auth/domain/entities/profile_entity.dart';
import '/features/auth/presentation/cubit/profile_cubit/profile_cubit.dart';
import '/features/shared/profile/domain/entities/saved_address_entity.dart';
import '/features/shared/profile/domain/usecases/params/profile_params.dart';
import '/features/shared/profile/presentation/cubit/profile_management_cubit.dart';
import '/injection_container.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<ProfileCubit>(
          create: (_) => ServiceLocator.instance<ProfileCubit>()..getProfile(),
        ),
        BlocProvider<ProfileManagementCubit>(
          create: (_) =>
              ServiceLocator.instance<ProfileManagementCubit>()
                ..execute(const LoadAddresses()),
        ),
      ],
      child: Scaffold(
        backgroundColor: colors.backGround,
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileIsLoading || state is ProfileInitial) {
              return AppShimmer(
                child: Container(color: colors.lightBackGroundColor),
              );
            }
            if (state is ProfileError) {
              return Center(
                child: SelectableText.rich(
                  TextSpan(
                    text: state.message,
                    style: TextStyle(color: colors.errorColor),
                  ),
                ),
              );
            }
            final profile = (state as ProfileLoaded).profile;
            return RefreshIndicator(
              onRefresh: context.read<ProfileCubit>().getProfile,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsetsDirectional.fromSTEB(
                  16.w,
                  MediaQuery.paddingOf(context).top + 16.h,
                  16.w,
                  24.h,
                ),
                children: <Widget>[
                  _ProfileHeader(profile: profile),
                  Gaps.vGap16,
                  _ProfileDetails(profile: profile),
                  Gaps.vGap16,
                  const _AddressesSection(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});
  final ProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () => _editProfile(context),
          child: ClipOval(
            child: CachedNetworkImageWithFallback(
              imageUrl: profile.profilePictureUrl,
              width: 92.r,
              height: 92.r,
            ),
          ),
        ),
        Gaps.vGap8,
        Text(
          profile.fullName,
          style: TextStyles.bold24(color: colors.onboardingHeadline),
        ),
        Text(profile.email),
        TextButton(
          onPressed: () => _editProfile(context),
          child: Text('profile_edit'.tr),
        ),
      ],
    );
  }

  Future<void> _editProfile(BuildContext context) async {
    final nameController = TextEditingController(text: profile.fullName);
    final emailController = TextEditingController(text: profile.email);
    final phoneController = TextEditingController(text: profile.phoneNumber);
    File? avatar;
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('profile_edit'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'fullName'.tr),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'email'.tr),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'phoneNumber'.tr),
            ),
            TextButton.icon(
              onPressed: () async {
                final image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  avatar = File(image.path);
                }
              },
              icon: const Icon(Icons.photo),
              label: Text('profile_choose_avatar'.tr),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('save'.tr),
          ),
        ],
      ),
    );
    final hasChanges =
        avatar != null ||
        nameController.text.trim() != profile.fullName ||
        emailController.text.trim() != profile.email ||
        phoneController.text.trim() != (profile.phoneNumber ?? '');
    if (shouldSave == true && hasChanges && context.mounted) {
      await context.read<ProfileManagementCubit>().execute(
        SaveProfile(
          UpdateProfileParams(
            fullName: nameController.text.trim() == profile.fullName
                ? null
                : nameController.text.trim(),
            email: emailController.text.trim() == profile.email
                ? null
                : emailController.text.trim(),
            phoneNumber:
                phoneController.text.trim() == (profile.phoneNumber ?? '')
                ? null
                : phoneController.text.trim(),
            profilePicture: avatar,
          ),
        ),
      );
      if (context.mounted) {
        // Resolve both cubits up front: reading the second one after the
        // first await would touch context across an async gap.
        final profileCubit = context.read<ProfileCubit>();
        final managementCubit = context.read<ProfileManagementCubit>();
        await profileCubit.getProfile();
        await managementCubit.execute(const LoadAddresses());
      }
    }
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }
}

class _ProfileDetails extends StatelessWidget {
  const _ProfileDetails({required this.profile});
  final ProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsetsDirectional.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${'email'.tr}: ${profile.email}'),
            Text('${'phoneNumber'.tr}: ${profile.phoneNumber ?? '-'}'),
            Text(
              '${'profile_email_confirmed'.tr}: '
              '${profile.emailConfirmed ? 'yes'.tr : 'no'.tr}',
            ),
            TextButton(
              onPressed: () => _changePassword(context),
              child: Text('profile_change_password'.tr),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changePassword(BuildContext context) async {
    final currentPassword = TextEditingController();
    final newPassword = TextEditingController();
    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('profile_change_password'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: currentPassword,
              obscureText: true,
              decoration: InputDecoration(labelText: 'current_password'.tr),
            ),
            TextField(
              controller: newPassword,
              obscureText: true,
              decoration: InputDecoration(labelText: 'new_password'.tr),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('save'.tr),
          ),
        ],
      ),
    );
    if (save == true && context.mounted) {
      await context.read<ProfileManagementCubit>().execute(
        SavePassword(
          ChangePasswordParams(
            currentPassword: currentPassword.text,
            newPassword: newPassword.text,
          ),
        ),
      );
      if (context.mounted) {
        await context.read<ProfileManagementCubit>().execute(
          const LoadAddresses(),
        );
      }
    }
    currentPassword.dispose();
    newPassword.dispose();
  }
}

class _AddressesSection extends StatelessWidget {
  const _AddressesSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsetsDirectional.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'profile_my_addresses'.tr,
                    style: TextStyles.bold18(color: colors.onboardingHeadline),
                  ),
                ),
                IconButton(
                  onPressed: () => context
                      .read<ProfileManagementCubit>()
                      .execute(CaptureCurrentAddress('current_location'.tr)),
                  icon: const Icon(Icons.add_location_alt_rounded),
                ),
              ],
            ),
            BlocBuilder<ProfileManagementCubit, ProfileManagementState>(
              builder: (context, state) {
                if (state is ProfileManagementLoading) {
                  return AppShimmer(
                    child: Container(
                      height: 80.h,
                      width: double.infinity,
                      color: colors.lightBackGroundColor,
                    ),
                  );
                }
                if (state is ProfileManagementFailure) {
                  return SelectableText.rich(
                    TextSpan(
                      text: state.message.tr,
                      style: TextStyle(color: colors.errorColor),
                    ),
                  );
                }
                final addresses = state is ProfileAddressesSuccess
                    ? state.addresses
                    : const <SavedAddressEntity>[];
                return Column(
                  children: addresses
                      .map(
                        (address) => ListTile(
                          title: Text(address.label),
                          subtitle: Text(address.addressLine),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => context
                                .read<ProfileManagementCubit>()
                                .execute(RemoveAddress(address.id)),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
