import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/_SharedData/AbstractDrawer.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/AssetsManager.dart';
import 'package:baha_platform/utils/Resouces/ValuesManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../ExceptionHandler/MessageController.dart';
import '../../../../ExceptionHandler/MessageEmitter.dart';
import '../../../../Router/MyRoutes.gr.dart';
import '../../../../utils/Resouces/theme.dart';
import '../../../AuthenticationFeature/Data/AuthController.dart';
import '../../../AuthenticationFeature/Domain/UserResponseDTO.dart';
import '../../../AuthenticationFeature/Domain/UserRole.dart';
import '../../../SplashFeature/ErrorView.dart';
import '../../../SplashFeature/LoadingView.dart';
import '../Domain/ShopOverview.dart';
import 'Providers/ShopProviders.dart';
import '_Widgets/ProductOverviewWidget.dart';

@RoutePage()
class SingleShopView extends ConsumerWidget {
  final ShopOverview shopOverview;

  const SingleShopView({super.key, required this.shopOverview});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopInformation =
        ref.watch(shopInformationByIdProvider(shopOverview.shopId));
    if (shopOverview.shopId ==
        ref.watch(authControllerProvider).value?.user?.uid) {
      ref
        ..listen<AsyncValue<UserRole?>>(authControllerProvider,
            (previous, next) {
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
    }
    return Scaffold(
      appBar: AppBar(
        title: shopInformation.when(
          data: (data) => Text(data.name),
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
      drawer: shopOverview.shopId ==
              ref.watch(authControllerProvider).requireValue?.user?.uid
          ? const AbstractDrawer(userRoleEnum: UserRoleEnum.shop)
          : null,
      body: Container(
        decoration: ThemeManager.scaffoldBackground,
        child: ref.watch(shopAllProductsProvider(shopOverview)).when(
              data: (data) => CustomScrollView(
                slivers: [
                  buildImage(shopInformation.maybeWhen(
                      data: (data) => data.personalImageURL,
                      orElse: () => shopOverview.personalImageURL)),
                  SliverPadding(
                    padding: const EdgeInsets.all(PaddingValuesManager.p10),
                    sliver: buildDescription(shopInformation, ref),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(PaddingValuesManager.p10),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ProductOverviewWidget(product: data[index]);
                        },
                        childCount: data.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 4,
                      ),
                    ),
                  ),
                ],
              ),
              error: (error, stackTrace) => ErrorView(error: error),
              loading: () => const LoadingView(),
            ),
      ),
    );
  }

  Widget buildImage(String imageUrl) => SliverToBoxAdapter(
        child: Stack(children: [
          Image.network(imageUrl,
              fit: BoxFit.cover,
              height: 300,
              width: double.infinity,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                    height: 300,
                    child: Center(
                        child: Icon(IconsAssetsManager.imageNotAvailable,
                            size: 48)),
                  )),
          buildOverlay()
        ]),
      );

  Widget buildDescription(
          AsyncValue<UserResponseDTO> shopInformation, WidgetRef ref) =>
      SliverToBoxAdapter(
        child: shopInformation.maybeWhen(
          data: (data) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    const Icon(IconsAssetsManager.serviceProviderDescription),
                    Flexible(
                      child: Text(
                        ref.getLocalizedString(data.description!),
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: PaddingValuesManager.p10,
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        data.addressString,
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => Uri.parse(data.addressURL).launch(),
                      icon: const Icon(IconsAssetsManager.addressURLOnMap),
                    ),
                  ],
                ),
              ),
            ],
          ),
          orElse: () => const SizedBox(height: AppSizeManager.s20),
        ),
      );

  Widget buildOverlay() => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Colors.transparent,
                ColorManager.surface.withOpacity(1),
              ],
            ),
          ),
        ),
      );
}
