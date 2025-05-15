import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/utils/Resouces/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/Resouces/ValuesManager.dart';
import '../../../AuthenticationFeature/Domain/UserRole.dart';
import '../../../SplashFeature/ErrorView.dart';
import '../../../SplashFeature/LoadingView.dart';
import 'Providers/ShopProviders.dart';
import '_Widgets/ShopOverviewWidget.dart';

const _productiveFamiliesImages = [];
const _agriculturalImages = [];
const _artisanImages = [];

@RoutePage()
class ShopsTypeTabView extends ConsumerWidget {
  final ShopTypeEnum shopType;

  const ShopsTypeTabView({super.key, required this.shopType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(shopsOverviewByTypeProvider(shopType)).when(
          data: (data) => Container(
            decoration: ThemeManager.scaffoldBackground,
            child: Padding(
              padding: const EdgeInsets.all(PaddingValuesManager.p20),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) => ShopOverviewWidget(
                            shopOverview: data.elementAt(index))),
                  ),
                ],
              ),
            ),
          ),
          error: (error, stackTrace) => ErrorView(error: error),
          loading: () => const LoadingView(),
        );
  }

  /*
  Widget buildImagesSlider()=>
      CarouselSlider(
        options: CarouselOptions(
          height: 300.0,
          viewportFraction: 1.0,
          autoPlay: true,
          enlargeCenterPage: false,
        ),
        items: ref.watch(provider).images.map((url) {Builder(
            builder: (BuildContext context) {
              ShopTypeEnum.artisanShop
              return Image.file(
                File(url),
                fit: BoxFit.contain,
                width: double.infinity,
              );
            },
          );
        }).toList(),
      );

   */
}
