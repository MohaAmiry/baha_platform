import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/_SharedData/TextIcon.dart';
import 'package:baha_platform/Router/MyRoutes.gr.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/AssetsManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Domain/Order.dart';

class OrderOverviewWidget extends ConsumerWidget {
  final Order order;

  const OrderOverviewWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        child: InkWell(
      onTap: () =>
          context.router.push(ShopCustomerSingleOrderRoute(order: order)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextIconWidget(
                icon: IconsAssetsManager.date,
                text: Text(order.orderTime.toRegularDateWithTime(context),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold))),
            const Divider(),
            Text(
                "${context.strings.amountOfProducts}: ${order.products.length}"),
            Text(
                "${context.strings.orderOwnerName}: ${order.customerInfo.name}"),
            Text("${context.strings.shopName}: ${order.shopOverview.shopName}"),
            Text("${context.strings.shopType}: ${order.shopOverview.shopName}"),
          ],
        ),
      ),
    ));
  }
}
