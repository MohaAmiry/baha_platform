import 'package:baha_platform/Localization/LocalizationProvider.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/AssetsManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../utils/Resouces/ValuesManager.dart';
import '../../../../../utils/Resouces/theme.dart';
import '../../Domain/CartProduct.dart';
import '../Notifiers/CartNotifiers.dart';

class CartProductWidget extends ConsumerWidget {
  final CartProduct cartProduct;

  const CartProductWidget({super.key, required this.cartProduct});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 100,
                height: 100,
                child: Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSizeManager.s5),
                        child: Image.network(
                          fit: BoxFit.cover,
                          cartProduct.product.images.first,
                        )))),
            const VerticalDivider(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ref.getLocalizedString(cartProduct.product.name),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorManager.secondary,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    ref.getLocalizedString(cartProduct.product.description),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: ColorManager.outline),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${cartProduct.product.price.toStringAsFixed(2)} ${context.strings.sr}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Divider(),
                  getCustomerButtons(context, ref)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getCustomerButtons(BuildContext context, WidgetRef ref) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [Text("${cartProduct.amount}x = "), totalCost(ref)],
              ),
              IconButton(
                  onPressed: () => ref
                      .read(customerCartProvider.notifier)
                      .removeFromCart(cartProduct.product.productId,
                          cartProduct.product.shopOverview.shopId),
                  icon: const Icon(
                    IconsAssetsManager.delete,
                    color: ColorManager.error,
                    //color: ColorManager.error,
                  ))
            ],
          ),
        ],
      );

  Widget totalCost(WidgetRef ref) =>
      Text("${cartProduct.totalRaw} ${ref.watch(localizationProvider).sr}");
}
