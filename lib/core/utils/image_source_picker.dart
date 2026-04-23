import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

/// Shows a bottom sheet to choose between camera and gallery for image capture.
/// Returns the selected [ImageSource] or null if cancelled.
Future<ImageSource?> showImageSourcePicker(BuildContext context) async {
  return await showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: colors.whiteColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'choose_image_source'.tr,
              style: TextStyles.bold18(color: colors.textColor),
              textAlign: TextAlign.center,
            ),
            Gaps.vGap20,
            ListTile(
              leading: Icon(Icons.camera_alt, color: colors.main),
              title: Text('camera'.tr, style: TextStyles.medium16(color: colors.textColor)),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: colors.main),
              title: Text('gallery'.tr, style: TextStyles.medium16(color: colors.textColor)),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            Gaps.vGap8,
          ],
        ),
      ),
    ),
  );
}
