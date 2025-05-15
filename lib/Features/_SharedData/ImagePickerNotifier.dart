import 'package:baha_platform/Localization/LocalizationProvider.dart';
import 'package:baha_platform/utils/Resouces/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../ExceptionHandler/MessageEmitter.dart';

part 'ImagePickerNotifier.g.dart';

@riverpod
class ImagePickerNotifier extends _$ImagePickerNotifier {
  @override
  List<XFile> build() {
    return [];
  }

  Future<List<String>> pickImages() async {
    AsyncValue<List<XFile>> result = await AsyncValue.guard(() async {
      return await ImagePicker().pickMultiImage();
    });
    if (result.hasError) {
      ref.read(messageEmitterProvider.notifier).setFailed(
          message: Exception(result.error.toString()),
          stackTrace: StackTrace.empty);
      return [];
    }
    state = result.requireValue;

    return result.requireValue.map((e) async => e.path).wait;
  }

  Future<XFile?> pickImage() async {
    AsyncValue<XFile?> result = await AsyncValue.guard(() async {
      return ImagePicker().pickMedia();
    });
    if (result.hasError) {
      ref.read(messageEmitterProvider.notifier).setFailed(
          message: Exception(result.error.toString()),
          stackTrace: StackTrace.empty);
      return null;
    }
    return result.value;
  }

  Future<XFile?> pickProfileImage() async {
    AsyncValue<XFile?> result = await AsyncValue.guard(() async {
      return ImagePicker().pickMedia();
    });
    if (result.hasError) {
      ref.read(messageEmitterProvider.notifier).setFailed(
          message: Exception(result.error.toString()),
          stackTrace: StackTrace.empty);
      return null;
    }
    if (result.value == null) return null;

    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: result.requireValue!.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: ref.read(localizationProvider).personalImage,
          toolbarColor: ColorManager.primary,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: ref.read(localizationProvider).personalImage,
          aspectRatioLockEnabled: true,
        )
      ],
    );
    return croppedFile == null ? null : XFile(croppedFile.path);
  }

  void removeSelectedImages() => state = [];
}
