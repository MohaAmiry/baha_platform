import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserRole.dart';
import 'package:baha_platform/Features/MarketFeature/ShopFeature/Presentation/Providers/ShopProviders.dart';
import 'package:baha_platform/Features/SplashFeature/ErrorView.dart';
import 'package:baha_platform/Features/SplashFeature/LoadingView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '_Widgets/ProductOverviewWidget.dart';

@RoutePage()
class ProductsTypeView extends ConsumerWidget {
  final ShopTypeEnum shopType;

  const ProductsTypeView({super.key, required this.shopType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(productsByTypeProvider(shopType)).when(
          data: (data) => GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 4,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ProductOverviewWidget(product: data.elementAt(index));
            },
          ),
          error: (error, stackTrace) => ErrorView(error: error),
          loading: () => const LoadingView(),
        );
  }
}
