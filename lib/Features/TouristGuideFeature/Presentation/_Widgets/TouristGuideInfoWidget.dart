import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserResponseDTO.dart';
import 'package:baha_platform/Features/_SharedData/TextIcon.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/AssetsManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/Resouces/ValuesManager.dart';

class TouristGuideInfoWidget extends ConsumerWidget {
  final UserResponseDTO touristGuide;

  const TouristGuideInfoWidget({super.key, required this.touristGuide});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            touristGuide.personalImageURL,
            fit: BoxFit.cover,
            height: MediaQuery.sizeOf(context).height * 0.3,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(PaddingValuesManager.p10),
            child: Column(
              children: [
                TextIconWidget(
                  icon: IconsAssetsManager.name,
                  text: Text(touristGuide.name),
                ),
                Row(
                  children: [
                    TextIconWidget(
                        icon: IconsAssetsManager.phoneNumber,
                        text: Text(touristGuide.phoneNumber)),
                    IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () async => await Uri(
                                scheme: "tel", path: touristGuide.phoneNumber)
                            .launchPhoneCall(),
                        icon: const Icon(IconsAssetsManager.call))
                  ],
                ),
                Row(
                  children: [
                    TextIconWidget(
                      icon: IconsAssetsManager.whatsAppPhoneNumber,
                      text: Text(touristGuide.whatsAppPhoneNumber!),
                    ),
                    IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () async => await Uri.parse(
                                "https://wa.me/${touristGuide.whatsAppPhoneNumber!.replaceFirst("0", "966")}")
                            .launch(),
                        icon: const Icon(IconsAssetsManager.send))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "${context.strings.address}: ${touristGuide.addressString}"),
                    IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () async =>
                            await Uri.parse(touristGuide.addressURL).launch(),
                        icon: const Icon(IconsAssetsManager.addressURLOnMap))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
