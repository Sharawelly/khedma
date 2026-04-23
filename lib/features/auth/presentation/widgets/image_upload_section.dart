import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/widgets/image_upload_widget.dart';
import '../cubit/register_form_cubit/register_form_cubit.dart';
import '../cubit/register_form_cubit/register_form_state.dart';

class ImageUploadSection extends StatelessWidget {
  const ImageUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterFormCubit, RegisterFormState>(
      builder: (context, state) {
        return ImageUploadWidget(
          selectedImage: state.selectedImage,
          onImageSelected: (File? image) {
            context.read<RegisterFormCubit>().selectImage(image);
          },
        );
      },
    );
  }
}
