import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserRole.dart';
import 'package:baha_platform/Features/_SharedData/AbstractDrawer.dart';
import 'package:baha_platform/Router/MyRoutes.gr.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../AuthenticationFeature/Data/AuthController.dart';

@RoutePage()
class AllProductsTabsView extends ConsumerWidget {
  const AllProductsTabsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoTabsRouter.tabBar(
      routes: [
        ProductsTypeRoute(shopType: ShopTypeEnum.productiveFamilyShop),
        ProductsTypeRoute(shopType: ShopTypeEnum.agriculturalShop),
        ProductsTypeRoute(shopType: ShopTypeEnum.artisanShop)
      ],
      builder: (context, child, tabController) {
        return Scaffold(
            endDrawer: ref.watch(authControllerProvider).value.runtimeType ==
                    Customer
                ? const AbstractDrawer(
                    userRoleEnum: UserRoleEnum.customer, isCustomerMarket: true)
                : ref.watch(authControllerProvider).value.runtimeType == Admin
                    ? const AbstractDrawer(
                        userRoleEnum: UserRoleEnum.admin,
                        isCustomerMarket: true)
                    : null,
            appBar: AppBar(
              title: Text(context.strings.products),
              bottom: TabBar(controller: tabController, tabs: [
                buildTab(ShopTypeEnum.productiveFamilyShop, ref),
                buildTab(ShopTypeEnum.agriculturalShop, ref),
                buildTab(ShopTypeEnum.artisanShop, ref),
              ]),
            ),
            body: child);
      },
    );
  }

  Tab buildTab(ShopTypeEnum shopType, WidgetRef ref) =>
      Tab(text: ref.getLocalizedProductsType(shopType));
}
