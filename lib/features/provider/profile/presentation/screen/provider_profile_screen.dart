import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/cached_network_image_with_fallback.dart';
import '/core/widgets/app_shimmer.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/image_viewer.dart';
import '/features/auth/domain/entities/profile_entity.dart';
import '/features/auth/presentation/cubit/profile_cubit/profile_cubit.dart';
import '/features/shared/profile/domain/entities/profile_image_entity.dart';
import '/features/shared/profile/domain/usecases/params/profile_params.dart';
import '/features/shared/profile/presentation/cubit/profile_management_cubit.dart';
import '/features/shared/location/presentation/screen/location_picker_screen.dart';
import '/features/shared/profile/presentation/widgets/profile_sign_out_button.dart';
import '/injection_container.dart';
import '../../../presentation/widgets/provider_working_location_card.dart';
import '../widgets/provider_services_section.dart';

class ProviderProfileScreen extends StatelessWidget {
  const ProviderProfileScreen({super.key});

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
                ..execute(const LoadProviderMedia()),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SelectableText.rich(
                      TextSpan(
                        text: state.message,
                        style: TextStyle(color: colors.errorColor),
                      ),
                    ),
                    TextButton(
                      onPressed: context.read<ProfileCubit>().getProfile,
                      child: Text('retry'.tr),
                    ),
                  ],
                ),
              );
            }
            final profile = (state as ProfileLoaded).profile;
            return RefreshIndicator(
              onRefresh: () async {
                await Future.wait<void>(<Future<void>>[
                  context.read<ProfileCubit>().getProfile(),
                  context.read<ProfileManagementCubit>().execute(
                    const LoadProviderMedia(),
                  ),
                ]);
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsetsDirectional.fromSTEB(
                  16.w,
                  MediaQuery.paddingOf(context).top + 16.h,
                  16.w,
                  24.h,
                ),
                children: <Widget>[
                  _ProviderHeader(profile: profile),
                  Gaps.vGap16,
                  _ProviderDetails(profile: profile),
                  Gaps.vGap16,
                  _ProviderWorkingLocation(profile: profile),
                  Gaps.vGap16,
                  const ProviderServicesSection(),
                  Gaps.vGap16,
                  const _ProviderMedia(),
                  Gaps.vGap24,
                  const ProfileSignOutButton(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProviderHeader extends StatelessWidget {
  const _ProviderHeader({required this.profile});
  final ProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ClipOval(
          child: CachedNetworkImageWithFallback(
            imageUrl: profile.profilePictureUrl,
            width: 92.r,
            height: 92.r,
          ),
        ),
        Gaps.vGap8,
        Text(
          profile.fullName,
          style: TextStyles.bold24(color: colors.onboardingHeadline),
        ),
        Text(profile.jobTitle ?? ''),
        Text(
          '${profile.rating?.toStringAsFixed(1) ?? '0.0'} · '
          '${profile.reviewCount ?? 0} ${'provider_reviews'.tr}',
        ),
        TextButton(
          onPressed: () => _edit(context),
          child: Text('profile_edit'.tr),
        ),
      ],
    );
  }

  Future<void> _edit(BuildContext context) async {
    final name = TextEditingController(text: profile.fullName);
    final phone = TextEditingController(text: profile.phoneNumber);
    final jobTitle = TextEditingController(text: profile.jobTitle);
    final serviceArea = TextEditingController(text: profile.serviceArea);
    final hourlyRate = TextEditingController(
      text: profile.hourlyRate?.toString(),
    );
    final experience = TextEditingController(
      text: profile.experienceYears?.toString(),
    );
    final description = TextEditingController(text: profile.description);
    File? avatar;
    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('profile_edit'.tr),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _field(name, 'fullName'),
              _field(phone, 'phoneNumber'),
              _field(jobTitle, 'providerRegisterJobTitle'),
              _field(serviceArea, 'providerRegisterServiceArea'),
              _field(hourlyRate, 'providerRegisterHourlyRate'),
              _field(experience, 'providerRegisterExperience'),
              _field(description, 'providerRegisterDescription'),
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
        name.text.trim() != profile.fullName ||
        phone.text.trim() != (profile.phoneNumber ?? '') ||
        jobTitle.text.trim() != (profile.jobTitle ?? '') ||
        serviceArea.text.trim() != (profile.serviceArea ?? '') ||
        double.tryParse(hourlyRate.text) != profile.hourlyRate ||
        int.tryParse(experience.text) != profile.experienceYears ||
        description.text.trim() != (profile.description ?? '');
    if (save == true && hasChanges && context.mounted) {
      await context.read<ProfileManagementCubit>().execute(
        SaveProfile(
          UpdateProfileParams(
            fullName: name.text.trim() == profile.fullName
                ? null
                : name.text.trim(),
            phoneNumber: phone.text.trim() == (profile.phoneNumber ?? '')
                ? null
                : phone.text.trim(),
            jobTitle: jobTitle.text.trim() == (profile.jobTitle ?? '')
                ? null
                : jobTitle.text.trim(),
            serviceArea: serviceArea.text.trim() == (profile.serviceArea ?? '')
                ? null
                : serviceArea.text.trim(),
            hourlyRate: double.tryParse(hourlyRate.text) == profile.hourlyRate
                ? null
                : double.tryParse(hourlyRate.text),
            experienceYears:
                int.tryParse(experience.text) == profile.experienceYears
                ? null
                : int.tryParse(experience.text),
            description: description.text.trim() == (profile.description ?? '')
                ? null
                : description.text.trim(),
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
        await managementCubit.execute(const LoadProviderMedia());
      }
    }
    for (final controller in <TextEditingController>[
      name,
      phone,
      jobTitle,
      serviceArea,
      hourlyRate,
      experience,
      description,
    ]) {
      controller.dispose();
    }
  }

  Widget _field(TextEditingController controller, String key) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: key.tr),
    );
  }
}

class _ProviderDetails extends StatelessWidget {
  const _ProviderDetails({required this.profile});
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
            Text('${'provider_hourly_rate'.tr}: ${profile.hourlyRate ?? '-'}'),
            Text(
              '${'provider_working_area'.tr}: ${profile.serviceArea ?? '-'}',
            ),
            Text(
              '${'provider_jobs_done'.tr}: ${profile.numberOfJobsDone ?? 0}',
            ),
            _AccountStatus(state: profile.state),
            if (profile.description?.isNotEmpty == true)
              Text(profile.description!),
          ],
        ),
      ),
    );
  }
}

/// Approval state, shown because dispatch skips anyone who is not Active - a
/// provider could otherwise sit online with services and a location set and
/// never learn why no work arrives.
class _AccountStatus extends StatelessWidget {
  const _AccountStatus({required this.state});
  final String? state;

  bool get _isActive => state?.toLowerCase() == 'active';

  String get _label => switch (state?.toLowerCase()) {
    'active' => 'provider_state_active'.tr,
    'pending' => 'provider_state_pending'.tr,
    'suspended' => 'provider_state_suspended'.tr,
    'banned' => 'provider_state_banned'.tr,
    _ => state ?? '-',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${'provider_account_status'.tr}: $_label',
          style: TextStyles.bold16(
            color: _isActive ? colors.onboardingHeadline : colors.errorColor,
          ),
        ),
        if (!_isActive)
          Padding(
            padding: EdgeInsetsDirectional.only(top: 4.h),
            child: Text(
              'provider_not_approved_warning'.tr,
              style: TextStyles.regular14(color: colors.errorColor),
            ),
          ),
      ],
    );
  }
}

/// The point this provider is dispatched from, mirrored here so it is visible
/// alongside the rest of their details rather than only on the jobs screen.
class _ProviderWorkingLocation extends StatelessWidget {
  const _ProviderWorkingLocation({required this.profile});
  final ProfileEntity profile;

  Future<void> _change(BuildContext context) async {
    final management = context.read<ProfileManagementCubit>();
    final profileCubit = context.read<ProfileCubit>();
    final latitude = profile.workingLatitude;
    final longitude = profile.workingLongitude;
    final picked = await Navigator.of(context).push<PickedLocation>(
      MaterialPageRoute<PickedLocation>(
        builder: (_) => LocationPickerScreen(
          title: 'location_picker_provider_title'.tr,
          initial: latitude != null && longitude != null
              ? LatLng(latitude, longitude)
              : null,
        ),
      ),
    );
    if (picked == null) {
      return;
    }
    // Only the coordinates are sent - every other field is omitted from the
    // payload, so a partial update cannot blank out the rest of the profile.
    await management.execute(
      SaveProfile(
        UpdateProfileParams(
          currentLatitude: picked.latitude,
          currentLongitude: picked.longitude,
        ),
      ),
    );
    // Re-read so the card reflects the saved point rather than the local guess.
    await profileCubit.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWorkingLocationCard(
      latitude: profile.workingLatitude,
      longitude: profile.workingLongitude,
      onChange: () => unawaited(_change(context)),
    );
  }
}

class _ProviderMedia extends StatelessWidget {
  const _ProviderMedia();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileManagementCubit, ProfileManagementState>(
      builder: (context, state) {
        if (state is ProfileManagementLoading) {
          return AppShimmer(
            child: Container(
              height: 140.h,
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
        final certificates = state is ProfileMediaSuccess
            ? state.certificates
            : const <ProfileImageEntity>[];
        final portfolio = state is ProfileMediaSuccess
            ? state.portfolio
            : const <ProfileImageEntity>[];
        return Column(
          children: <Widget>[
            _MediaSection(
              title: 'provider_profile_certificates'.tr,
              images: certificates,
              certificate: true,
            ),
            Gaps.vGap16,
            _MediaSection(
              title: 'provider_profile_portfolio'.tr,
              images: portfolio,
              certificate: false,
            ),
          ],
        );
      },
    );
  }
}

class _MediaSection extends StatelessWidget {
  const _MediaSection({
    required this.title,
    required this.images,
    required this.certificate,
  });

  final String title;
  final List<ProfileImageEntity> images;
  final bool certificate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsetsDirectional.all(12.r),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: TextStyles.bold18(color: colors.onboardingHeadline),
                  ),
                ),
                IconButton(
                  onPressed: () => _upload(context),
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                ),
              ],
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: images.length,
              itemBuilder: (_, index) {
                final image = images[index];
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    // The delete button sits above this in the stack, so tapping
                    // it does not also open the viewer.
                    GestureDetector(
                      onTap: () => unawaited(
                        showImageViewer(
                          context,
                          images: images
                              .map((entry) => entry.imageUrl)
                              .toList(),
                          initialIndex: index,
                        ),
                      ),
                      child: CachedNetworkImageWithFallback(
                        imageUrl: image.imageUrl,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: IconButton(
                        onPressed: () =>
                            context.read<ProfileManagementCubit>().execute(
                              RemoveProviderMedia(
                                id: image.id,
                                certificate: certificate,
                              ),
                            ),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _upload(BuildContext context) async {
    final selected = await ImagePicker().pickMultiImage();
    if (selected.isNotEmpty && context.mounted) {
      await context.read<ProfileManagementCubit>().execute(
        UploadProviderMedia(
          files: selected.map((image) => File(image.path)).toList(),
          certificate: certificate,
        ),
      );
    }
  }
}
