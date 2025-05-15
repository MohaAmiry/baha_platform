import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserRole.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Presentation/Notifiers/ProfileNotifier.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Presentation/_Widgets/ProfileImageWidget.dart';
import 'package:baha_platform/Features/SplashFeature/ErrorView.dart';
import 'package:baha_platform/Features/_SharedData/TextIcon.dart';
import 'package:baha_platform/Localization/LocalizationRepository.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/AssetsManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Router/MyRoutes.gr.dart';
import '../../../utils/Resouces/ValuesManager.dart';
import '../../../utils/Resouces/theme.dart';
import '../../SplashFeature/LoadingView.dart';

@RoutePage()
class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(context.strings.personalInformation,
            style: Theme.of(context).textTheme.titleLarge),
        actions: [
          ref.watch(profileNotifierProvider).maybeWhen(
              data: (data) => IconButton(
                  onPressed: () => context.router
                      .push(EditProfileRoute(userResponseDTO: data)),
                  icon: const Icon(Icons.edit)),
              orElse: () => Container())
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: ThemeManager.scaffoldBackground,
        child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: PaddingValuesManager.p20,
                vertical: PaddingValuesManager.p20),
            child: ref.watch(profileNotifierProvider).when(
                  data: (data) => SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: ProfileImageWidget(
                                profileImageURL: data.personalImageURL,
                                managementFunctions: (
                                  addFunc: ref
                                      .read(profileNotifierProvider.notifier)
                                      .updateUserImage,
                                  removeFunc: ref
                                      .read(profileNotifierProvider.notifier)
                                      .removeUserImage
                                )),
                          ),
                          TextIconWidget(
                              icon: IconsAssetsManager.name,
                              text: Text(
                                context.strings.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              )),
                          Text(data.name),
                          if (data.userRole == UserRoleEnum.touristGuide ||
                              data.userRole == UserRoleEnum.shop)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                TextIconWidget(
                                    icon: IconsAssetsManager
                                        .serviceProviderDescription,
                                    text: Text(
                                      context
                                          .strings.serviceProviderDescription,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    )),
                                Text(ref.getLocalizedString(data.description!)),
                              ],
                            ),
                          const Divider(),
                          TextIconWidget(
                              icon: IconsAssetsManager.email,
                              text: Text(
                                context.strings.email,
                                style: Theme.of(context).textTheme.titleLarge,
                              )),
                          Text(data.email),
                          const Divider(),
                          TextIconWidget(
                              icon: IconsAssetsManager.phoneNumber,
                              text: Text(
                                context.strings.phoneNumber,
                                style: Theme.of(context).textTheme.titleLarge,
                              )),
                          Text(data.phoneNumber),
                          const Divider(),
                          TextIconWidget(
                              icon: IconsAssetsManager.address,
                              text: Text(
                                context.strings.address,
                                style: Theme.of(context).textTheme.titleLarge,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(data.addressString),
                              IconButton(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () async =>
                                      await Uri.parse(data.addressURL).launch(),
                                  icon: const Icon(
                                      IconsAssetsManager.addressURLOnMap))
                            ],
                          ),
                          const Divider(),
                          switch (data.userRole) {
                            UserRoleEnum.admin => Container(),
                            UserRoleEnum.customer => Container(),
                            UserRoleEnum.shop => buildShopInformation(
                                ref, context, data.shopType!),
                            UserRoleEnum.touristGuide =>
                              buildTouristGuideInformation(
                                  context, data.whatsAppPhoneNumber!),
                          },
                        ],
                      ),
                    ),
                  ),
                  error: (error, stackTrace) => ErrorView(error: error),
                  loading: () => const LoadingView(),
                )),
      ),
    );
  }

  Widget buildShopInformation(
          WidgetRef ref, BuildContext context, ShopTypeEnum shopType) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextIconWidget(
              icon: IconsAssetsManager.shopType,
              text: Text(context.strings.shopType,
                  style: Theme.of(context).textTheme.titleLarge)),
          Text(ref
              .watch(localizationRepositoryProvider)
              .requireValue
              .getLocalizedShopType(shopType)),
          const Divider(),
        ],
      );

  Widget buildTouristGuideInformation(
          BuildContext context, String additionalPhoneNumber) =>
      Column(
        children: [
          TextIconWidget(
              icon: IconsAssetsManager.whatsAppPhoneNumber,
              text: Text(context.strings.whatsAppPhoneNumber,
                  style: Theme.of(context).textTheme.titleLarge)),
          Text(additionalPhoneNumber),
          const Divider(),
        ],
      );
}
