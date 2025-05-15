import 'package:baha_platform/utils/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../utils/Resouces/ValuesManager.dart';
import '../../../../../utils/Resouces/theme.dart';
import '../../Domain/CartProduct.dart';

class OrderProductWidget extends ConsumerWidget {
  final CartProduct cartProduct;

  const OrderProductWidget({super.key, required this.cartProduct});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
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
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${cartProduct.product.price.toStringAsFixed(2)} ${context.strings.sr}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Row(
                    children: [
                      Text("${cartProduct.amount}x = "),
                      totalCost(context)
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget totalCost(BuildContext context) =>
      Text("${cartProduct.totalRaw} ${context.strings.sr}");
}
