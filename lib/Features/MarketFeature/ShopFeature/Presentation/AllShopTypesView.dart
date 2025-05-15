import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Router/MyRoutes.gr.dart';
import '../../../AuthenticationFeature/Domain/UserRole.dart';

@RoutePage()
class AllShopTypesTabsView extends ConsumerWidget {
  const AllShopTypesTabsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoTabsRouter.tabBar(
      routes: [
        ShopsTypeTabRoute(shopType: ShopTypeEnum.productiveFamilyShop),
        ShopsTypeTabRoute(shopType: ShopTypeEnum.agriculturalShop),
        ShopsTypeTabRoute(shopType: ShopTypeEnum.artisanShop)
      ],
      builder: (context, child, tabController) {
        return Scaffold(
            appBar: AppBar(
              title: Text(context.strings.availableShops),
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
