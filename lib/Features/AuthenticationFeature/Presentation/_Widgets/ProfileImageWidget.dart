import 'dart:io';

import 'package:baha_platform/utils/Resouces/AssetsManager.dart';
import 'package:baha_platform/utils/Resouces/ValuesManager.dart';
import 'package:baha_platform/utils/Resouces/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileImageWidget extends ConsumerWidget {
  final String? profileImageURL;
  final ({VoidCallback addFunc, VoidCallback removeFunc})? managementFunctions;
  final double size;

  const ProfileImageWidget(
      {super.key,
      required this.profileImageURL,
      this.managementFunctions,
      this.size = AppSizeManager.s90});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CircleAvatar(
        radius: size,
        backgroundImage: profileImageURL?.startsWith("https") == true
            ? NetworkImage(profileImageURL!)
            : managementFunctions != null &&
                    profileImageURL?.startsWith("https") == false
                ? FileImage(File(profileImageURL!))
                : const AssetImage(ImageAssetsManager.defaultProfileImage),
        child: managementFunctions != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        onPressed: managementFunctions!.addFunc,
                        icon: const Icon(IconsAssetsManager.cameraIcon,
                            size: 30, color: ColorManager.secondary)),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: IconButton(
                        onPressed: managementFunctions!.removeFunc,
                        icon: const Icon(IconsAssetsManager.delete,
                            size: 30, color: ColorManager.secondary)),
                  ),
                ],
              )
            : Container());
  }
}
