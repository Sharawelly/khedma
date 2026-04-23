import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/image_source_picker.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class ImageUploadWidget extends StatelessWidget {
  final File? selectedImage;
  final String? imageUrl;
  final double? width;
  final double? height;
  final double? imageSize;
  final double? iconSize;
  final String? labelText;
  final bool showMaximumSizeOfImage;
  final Function(File)? onImageSelected;

  const ImageUploadWidget({
    super.key,
    this.selectedImage,
    this.imageUrl,
    this.width,
    this.height,
    this.imageSize,
    this.iconSize,
    this.labelText,
    this.showMaximumSizeOfImage = false,
    this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 5.h),
        width: width ?? double.infinity,
        height: height ?? 225.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: colors.main, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.file(
                      selectedImage!,
                      width: imageSize ?? 71.w,
                      height: imageSize ?? 71.h,
                      fit: BoxFit.cover,
                    ),
                  )
                : imageUrl != null && imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl!,
                          width: imageSize ?? 71.w,
                          height: imageSize ?? 71.h,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: imageSize ?? 71.w,
                            height: imageSize ?? 71.h,
                            color: colors.lightBackGroundColor,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: colors.main,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.broken_image,
                            size: (iconSize ?? 71).sp,
                            color: colors.textColor,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.add_photo_alternate_outlined,
                        size: (iconSize ?? 71).sp,
                        color: colors.textColor,
                      ),
            Gaps.vGap8,
            if (showMaximumSizeOfImage) ...[
              Gaps.vGap8,
              Center(
                child: Text(
                  'maximum_file_upload_size'.tr,
                  style: TextStyles.bold14(color: colors.textColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            Gaps.vGap8,
            GestureDetector(
              onTap: () => _pickImage(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                  border: Border.all(color: colors.main, width: 1.w),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  labelText ?? 'add_image'.tr,
                  style: TextStyles.bold16(color: colors.textColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    try {
      final ImageSource? source = await showImageSourcePicker(context);
      if (source == null || !context.mounted) return;

      final ImagePicker imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null && onImageSelected != null) {
        onImageSelected!(File(image.path));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('error_picking_image'.tr, textAlign: TextAlign.right),
            backgroundColor: colors.errorColor,
          ),
        );
      }
    }
  }
}
