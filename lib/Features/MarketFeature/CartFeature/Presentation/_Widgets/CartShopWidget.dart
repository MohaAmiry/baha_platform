import 'package:baha_platform/Features/MarketFeature/CartFeature/Presentation/_Widgets/CartProductWidget.dart';
import 'package:baha_platform/utils/Resouces/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Domain/CartShop.dart';

class CartShopWidget extends ConsumerStatefulWidget {
  final CartShop cartShop;

  const CartShopWidget({super.key, required this.cartShop});

  @override
  ConsumerState createState() => _CartShopWidgetState();
}

class _CartShopWidgetState extends ConsumerState<CartShopWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.cartShop.shopOverview.shopName,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: ColorManager.secondary,
                    fontWeight: FontWeight.bold)),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.cartShop.products.length,
              itemBuilder: (context, index) => CartProductWidget(
                  cartProduct: widget.cartShop.products.elementAt(index)),
            ),
          ],
        ),
      ),
    );
  }

  /*
  Widget switchTakeFromStore() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Radio(
                value: true,
                groupValue: widget.cartShop.takeFromStore,
                onChanged: (value) => ref
                    .read(customerCartProvider.notifier)
                    .setTakeFromStore(
                        value!, widget.cartShop.shopOverview.shopId),
              ),
              const Text(
                'اخذ من المتجر',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Radio(
                  value: false,
                  groupValue: widget.cartShop.takeFromStore,
                  onChanged: (value) => ref
                      .read(customerCartProvider.notifier)
                      .setTakeFromStore(
                          value!, widget.cartShop.shopOverview.shopId)),
              const Text(
                'توصيل',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      );

   */

  Widget getSummary(WidgetRef ref) => Column(children: [
        const Text("الملخص"),
        Text("المجموع: ${widget.cartShop.totalRaw}")
      ]);
}
