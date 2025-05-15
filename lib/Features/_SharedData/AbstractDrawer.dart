import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserRole.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Presentation/_Widgets/ProfileImageWidget.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Router/MyRoutes.gr.dart';
import '../../utils/Resouces/AssetsManager.dart';
import '../../utils/Resouces/ValuesManager.dart';
import '../../utils/Resouces/theme.dart';
import '../AuthenticationFeature/Data/AuthController.dart';
import 'AboutAppWidget.dart';
import 'LanguagesSwitchButtonWidget.dart';
import 'TextIcon.dart';

class AbstractDrawer extends ConsumerWidget {
  final UserRoleEnum userRoleEnum;
  final bool withWelcome;
  final bool isCustomerMarket;

  const AbstractDrawer(
      {super.key,
      required this.userRoleEnum,
      this.withWelcome = true,
      this.isCustomerMarket = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context)
        .textTheme
        .headlineMedium!
        .copyWith(color: ColorManager.secondary);
    return Drawer(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(height: MediaQuery.sizeOf(context).height * .1),
      if (withWelcome)
        Text(
            "${context.strings.welcome} ${ref.watch(authControllerProvider).value?.name}!",
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: ColorManager.primary),
            textAlign: TextAlign.center),
      ProfileImageWidget(
          size: AppSizeManager.s40,
          profileImageURL:
              ref.watch(authControllerProvider).value?.personalImageURL),
      Align(
          alignment: Alignment.centerRight,
          child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ...switch (userRoleEnum) {
                  UserRoleEnum.admin => isCustomerMarket
                      ? buildAdminMarket(context, textStyle, ref)
                      : buildAdmin(context, textStyle, ref),
                  UserRoleEnum.customer => isCustomerMarket
                      ? buildCustomerMarket(context, textStyle, ref)
                      : buildCustomer(context, textStyle, ref),
                  UserRoleEnum.shop => buildShop(context, textStyle, ref),
                  UserRoleEnum.touristGuide =>
                    buildTouristGuide(context, textStyle, ref),
                }
              ])),
      const Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: PaddingValuesManager.p10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(PaddingValuesManager.p10),
                child: LanguagesSwitchButtonWidget(),
              ),
              AboutAppWidget(),
            ],
          ),
        ),
      )
    ]));
  }

  List<Widget> buildAdmin(
          BuildContext context, TextStyle textStyle, WidgetRef ref) =>
      [
        ListTile(
            onTap: () => context.router.push(const AllContentTypesRoute()),
            title: TextIconWidget(
                icon: IconsAssetsManager.allContentTypes,
                text: Text(
                  context.strings.content,
                  style: textStyle,
                ))),
        ListTile(
            onTap: () => context.router.push((ContentManageRoute())),
            title: TextIconWidget(
                icon: IconsAssetsManager.addContent,
                text: Text(context.strings.addContent, style: textStyle))),
        ListTile(
            onTap: () => context.router.push(const AllProductsTabsRoute()),
            title: TextIconWidget(
                icon: IconsAssetsManager.market,
                text: Text(
                  context.strings.market,
                  style: textStyle,
                ))),
        ListTile(
            onTap: () => context.router.push(const TouristsGuidesListRoute()),
            title: TextIconWidget(
                icon: IconsAssetsManager.touristGuides,
                text: Text(context.strings.touristGuides, style: textStyle))),
        ListTile(
            onTap: () => context.router.push(const ProfileRoute()),
            title: TextIconWidget(
                icon: IconsAssetsManager.profile,
                text: Text(
                  context.strings.profile,
                  style: textStyle,
                ))),
        ListTile(
            onTap: () => ref.read(authControllerProvider.notifier).signOut(),
            title: TextIconWidget(
                icon: IconsAssetsManager.signOut,
                text: Text(
                  context.strings.signOut,
                  style: textStyle,
                ))),
      ];

  List<Widget> buildAdminMarket(
          BuildContext context, TextStyle textStyle, WidgetRef ref) =>
      [
        ListTile(
            onTap: () => context.router.push(const AllShopTypesTabsRoute()),
            title: TextIconWidget(
                icon: IconsAssetsManager.allShops,
                text: Text(
                  context.strings.availableShops,
                  style: textStyle,
                ))),
      ];

  List<Widget> buildCustomer(
          BuildContext context, TextStyle textStyle, WidgetRef ref) =>
      [
        ListTile(
            onTap: () => context.router.push(const AllProductsTabsRoute()),
            title: TextIconWidget(
                icon: IconsAssetsManager.market,
                text: Text(
                  context.strings.market,
                  style: textStyle,
                ))),
        ListTile(
            onTap: () => context.router.push(const TouristsGuidesListRoute()),
            title: TextIconWidget(
                icon: IconsAssetsManager.touristGuides,
                text: Text(context.strings.touristGuides, style: textStyle))),
        ListTile(
            onTap: () => context.router.push(const ProfileRoute()),
            title: TextIconWidget(
                icon: IconsAssetsManager.profile,
                text: Text(
                  context.strings.profile,
                  style: textStyle,
                ))),
        ListTile(
            onTap: () => ref.read(authControllerProvider.notifier).signOut(),
            title: TextIconWidget(
                icon: IconsAssetsManager.signOut,
                text: Text(
                  context.strings.signOut,
                  style: textStyle,
                ))),
      ];

  List<Widget> buildCustomerMarket(
          BuildContext context, TextStyle textStyle, WidgetRef ref) =>
      [
        ListTile(
            onTap: () => context.router.push(const AllShopTypesTabsRoute()),
            title: TextIconWidget(
                icon: IconsAssetsManager.allShops,
                text: Text(
                  context.strings.availableShops,
                  style: textStyle,
                ))),
        ListTile(
            onTap: () => context.router.push(const CartRoute()),
            title: TextIconWidget(
                icon: IconsAssetsManager.cart,
                text: Text(
                  context.strings.cart,
                  style: textStyle,
                ))),
        ListTile(
            onTap: () => context.router.push(const CustomerActiveOrdersRoute()),
            title: TextIconWidget(
                icon: IconsAssetsManager.myOrders,
                text: Text(
                  context.strings.myOrders,
                  style: textStyle,
                ))),
      ];

  List<Widget> buildShop(
          BuildContext context, TextStyle textStyle, WidgetRef ref) =>
      [
        ListTile(
            onTap: () =>
                context.router.push(ProductManagementRoute(productDTO: null)),
            title: TextIconWidget(
                icon: IconsAssetsManager.addProduct,
                text: Text(context.strings.addProduct, style: textStyle))),
        ListTile(
            onTap: () => context.router.push(const ShopAllOrdersRoute()),
            title: TextIconWidget(
                icon: IconsAssetsManager.myOrders,
                text: Text(context.strings.customersOrders, style: textStyle))),
        ListTile(
            onTap: () => context.router.push(const ProfileRoute()),
            title: TextIconWidget(
                icon: IconsAssetsManager.profile,
                text: Text(context.strings.profile, style: textStyle))),
        ListTile(
            onTap: () => ref.read(authControllerProvider.notifier).signOut(),
            title: TextIconWidget(
                icon: IconsAssetsManager.signOut,
                text: Text(context.strings.signOut, style: textStyle)))
      ];

  List<Widget> buildTouristGuide(
          BuildContext context, TextStyle textStyle, WidgetRef ref) =>
      [
        ListTile(
            onTap: () => ref.read(authControllerProvider.notifier).signOut(),
            title: TextIconWidget(
                icon: IconsAssetsManager.signOut,
                text: Text(context.strings.signOut, style: textStyle)))
      ];
}
