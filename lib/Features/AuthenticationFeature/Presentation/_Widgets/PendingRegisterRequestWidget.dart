import 'package:baha_platform/Features/AuthenticationFeature/Data/AuthController.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserResponseDTO.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserRole.dart';
import 'package:baha_platform/Localization/LocalizationRepository.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/Resouces/AssetsManager.dart';
import '../../../../utils/Resouces/ValuesManager.dart';

class PendingRegisterRequestWidget extends ConsumerWidget {
  final UserResponseDTO userResponseDTO;

  const PendingRegisterRequestWidget(
      {super.key, required this.userResponseDTO});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PaddingValuesManager.p10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizeManager.s5),
              child: Image.network(
                userResponseDTO.personalImageURL,
                fit: BoxFit.cover,
                height: MediaQuery.sizeOf(context).height * 0.3,
                width: double.infinity,
              ),
            ),
            const Divider(),
            Text("${context.strings.name}: ${userResponseDTO.name}"),
            Text(
                "${context.strings.serviceProviderDescription}: ${ref.getLocalizedString(userResponseDTO.description!)}"),
            Text(
                "${context.strings.serviceProviderType}: ${ref.watch(localizationRepositoryProvider).requireValue.getLocalizedServiceProviderType(userResponseDTO.userRole)}"),
            if (userResponseDTO.userRole == UserRoleEnum.shop)
              Text(
                  "${context.strings.shopType}: ${ref.watch(localizationRepositoryProvider).requireValue.getLocalizedShopType(userResponseDTO.shopType!)}"),
            Row(
              children: [
                Text(
                    "${context.strings.phoneNumber}: ${userResponseDTO.phoneNumber}"),
                IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () async => await Uri(
                            scheme: "tel", path: userResponseDTO.phoneNumber)
                        .launchPhoneCall(),
                    icon: const Icon(IconsAssetsManager.call))
              ],
            ),
            if (userResponseDTO.whatsAppPhoneNumber != null)
              Row(
                children: [
                  Text(
                      "${context.strings.whatsAppPhoneNumber}: ${userResponseDTO.whatsAppPhoneNumber}"),
                  IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () async => await Uri.parse(
                              "https://wa.me/${userResponseDTO.whatsAppPhoneNumber!.replaceFirst("0", "966")}")
                          .launch(),
                      icon: const Icon(IconsAssetsManager.send))
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "${context.strings.address}: ${userResponseDTO.addressString}"),
                IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () async =>
                        await Uri.parse(userResponseDTO.addressURL).launch(),
                    icon: const Icon(IconsAssetsManager.addressURLOnMap,
                        color: ColorManager.primary))
              ],
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () async => await ref
                        .read(authControllerProvider.notifier)
                        .approveUserByID(userResponseDTO.userId),
                    child: Text(context.strings.approveUser)),
                TextButton(
                    onPressed: () async => await ref
                        .read(authControllerProvider.notifier)
                        .disapproveUserByID(userResponseDTO.userId),
                    child: Text(
                      context.strings.disapproveUser,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: ColorManager.error),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
