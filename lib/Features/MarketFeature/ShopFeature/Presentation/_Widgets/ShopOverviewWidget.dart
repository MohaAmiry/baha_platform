import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Router/MyRoutes.gr.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/Resouces/ValuesManager.dart';
import '../../Domain/ShopOverview.dart';

class ShopOverviewWidget extends StatelessWidget {
  final ShopOverview shopOverview;

  const ShopOverviewWidget({super.key, required this.shopOverview});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizeManager.s10),
      ),
      child: InkWell(
        onTap: () =>
            context.router.push(SingleShopRoute(shopOverview: shopOverview)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              shopOverview.personalImageURL,
              fit: BoxFit.cover,
              height: MediaQuery.sizeOf(context).height * 0.3,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(PaddingValuesManager.p10),
              child: Column(
                children: [
                  Text(shopOverview.shopName,
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            )
          ],
        ),
      ),
    );

    /*
      Card(
      child: InkWell(
          onTap: () =>
              context.router.push(SingleShopRoute(shopOverview: shopOverview)),
          child: Center(
              child: SizedBox(
            height: 100,
            child: Center(
              child: Text(shopOverview.shopName,
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          ))),
    );
    */
  }
}
