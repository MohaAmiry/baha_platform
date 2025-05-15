import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'MyRoutes.gr.dart';

part 'MyRoutes.g.dart';

@AutoRouterConfig(replaceInRouteName: "View,Route")
class MyRoutes extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SplashRoute.page,
          initial: true,
        ),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegisterRoute.page),
        AutoRoute(page: ProfileRoute.page),
        AutoRoute(page: EditProfileRoute.page),
        AutoRoute(page: PendingRegisterRequestsRoute.page),
        AutoRoute(page: SingleShopRoute.page),
        AutoRoute(page: ProductManagementRoute.page),
        AutoRoute(page: ShopAllOrdersRoute.page),
        AutoRoute(page: ShopCustomerSingleOrderRoute.page),
        AutoRoute(page: ShopOrdersHistoryRoute.page),
        AutoRoute(page: CartRoute.page),
        AutoRoute(page: CustomerOrdersHistoryRoute.page),
        AutoRoute(page: CustomerActiveOrdersRoute.page),
        AutoRoute(page: TouristGuideHomeRoute.page),
        AutoRoute(page: AllContentTypesRoute.page, children: [
          AutoRoute(page: ContentTypeRoute.page),
        ]),
        AutoRoute(page: ContentRoute.page),
        AutoRoute(page: ContentManageRoute.page),
        AutoRoute(page: StoryCaptureRoute.page),
        AutoRoute(page: AboutApplicationRoute.page),
        AutoRoute(page: AllProductsTabsRoute.page, children: [
          AutoRoute(page: ProductsTypeRoute.page),
        ]),
        AutoRoute(
            page: AllShopTypesTabsRoute.page,
            children: [AutoRoute(page: ShopsTypeTabRoute.page)]),
        AutoRoute(page: SingleProductRoute.page),
        AutoRoute(page: StoriesTimelineRoute.page),
        AutoRoute(page: TouristsGuidesListRoute.page)
      ];
}

class MyObserver extends AutoRouterObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    log('New route pushed: ${route.settings.name}');
    //log('Current Stack State: ${route.settings.}');
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    log('Tab route visited: ${route.name}');
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    log('Tab route re-visited: ${route.name}');
  }
}

@riverpod
RouterConfig<UrlState> myRoutes(MyRoutesRef ref) {
  return MyRoutes().config(
    navigatorObservers: () => [MyObserver()],
  );
}
