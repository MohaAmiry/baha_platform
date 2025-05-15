import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserRole.dart';
import 'package:baha_platform/Features/_SharedData/AbstractDrawer.dart';
import 'package:baha_platform/Router/MyRoutes.gr.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ExceptionHandler/MessageController.dart';
import '../../../ExceptionHandler/MessageEmitter.dart';
import '../../../utils/Resouces/AssetsManager.dart';
import '../../../utils/Resouces/ValuesManager.dart';
import '../../../utils/Resouces/theme.dart';
import '../../AuthenticationFeature/Data/AuthController.dart';
import '../../AuthenticationFeature/Presentation/Notifiers/ProfileNotifier.dart';
import '../../AuthenticationFeature/Presentation/_Widgets/ProfileImageWidget.dart';
import '../../SplashFeature/ErrorView.dart';
import '../../SplashFeature/LoadingView.dart';
import '../../_SharedData/TextIcon.dart';

@RoutePage()
class TouristGuideHomeView extends ConsumerWidget {
  const TouristGuideHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..listen<AsyncValue<UserRole?>>(authControllerProvider, (previous, next) {
        next.whenData((data) {
          if (data == null) {
            return context.router.replaceAll([const LoginRoute()]);
          }
        });
      })
      ..listen(messageEmitterProvider, (previous, next) {
        next != null
            ? ref
                .read(MessageControllerProvider(context).notifier)
                .showToast(next)
            : null;
      });

    final provider = ref.watch(profileNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        actions: provider.maybeWhen(
            data: (data) => [
                  IconButton(
                      onPressed: () => context.router
                          .push(EditProfileRoute(userResponseDTO: data)),
                      icon: const Icon(IconsAssetsManager.edit))
                ],
            orElse: () => null),
        title: Text(context.strings.touristGuideInformation),
      ),
      drawer: const AbstractDrawer(userRoleEnum: UserRoleEnum.touristGuide),
      body: Container(
        height: double.infinity,
        decoration: ThemeManager.scaffoldBackground,
        child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: PaddingValuesManager.p20,
                vertical: PaddingValuesManager.p20),
            child: provider.when(
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
                        ),
                      ),
                      Text(data.name),
                      const Divider(),
                      TextIconWidget(
                          icon: IconsAssetsManager.serviceProviderDescription,
                          text: Text(
                            context.strings.serviceProviderDescription,
                            style: Theme.of(context).textTheme.titleLarge,
                          )),
                      Text(ref.getLocalizedString(data.description!)),
                      const Divider(),
                      TextIconWidget(
                        icon: IconsAssetsManager.email,
                        text: Text(
                          context.strings.email,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Text(data.email),
                      const Divider(),
                      TextIconWidget(
                        icon: IconsAssetsManager.phoneNumber,
                        text: Text(
                          context.strings.phoneNumber,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Text(data.phoneNumber),
                      const Divider(),
                      TextIconWidget(
                        icon: IconsAssetsManager.address,
                        text: Text(
                          context.strings.address,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data.addressString),
                          TextButton(
                              onPressed: () async =>
                                  await Uri.parse(data.addressURL).launch(),
                              child: Text(context.strings.link))
                        ],
                      ),
                      const Divider(),
                      TextIconWidget(
                          icon: IconsAssetsManager.whatsAppPhoneNumber,
                          text: Text(context.strings.whatsAppPhoneNumber,
                              style: Theme.of(context).textTheme.titleLarge)),
                      Text(data.whatsAppPhoneNumber!),
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
}
