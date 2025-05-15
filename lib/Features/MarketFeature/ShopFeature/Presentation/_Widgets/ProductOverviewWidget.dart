import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/MarketFeature/CartFeature/Presentation/Notifiers/CartNotifiers.dart';
import 'package:baha_platform/Features/_SharedData/TextIcon.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/ValuesManager.dart';
import 'package:baha_platform/utils/Resouces/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../Router/MyRoutes.gr.dart';
import '../../../../AuthenticationFeature/Data/AuthController.dart';
import '../../../../AuthenticationFeature/Domain/UserRole.dart';
import '../../Domain/Product.dart';
import '../Providers/ProductManagementNotifier.dart';

class ProductOverviewWidget extends ConsumerWidget {
  final Product product;

  const ProductOverviewWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        onTap: () => context.router.push(SingleProductRoute(product: product)),
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppSizeManager.s5)),
                  child: product.images.isNotEmpty
                      ? Image.network(
                          product.images[0],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported, size: 48),
                        )
                      : const Icon(Icons.image_not_supported, size: 48),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(PaddingValuesManager.p10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ref.getLocalizedString(product.name),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: ColorManager.secondary,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    ref.getLocalizedString(product.description),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: ColorManager.outline),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Divider(),
                  Text(
                    '${product.price.toStringAsFixed(2)} ${context.strings.sr}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  ref.watch(authControllerProvider).value is Shop
                      ? getShopButtons(context, ref)
                      : getCustomerButtons(context, ref)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getShopButtons(BuildContext context, WidgetRef ref) => Row(
        children: [
          Expanded(
            child: ElevatedButton(
                onPressed: () => context.router
                    .push(ProductManagementRoute(productDTO: product.toDTO())),
                child: Text(context.strings.editProduct,
                    textAlign: TextAlign.center)),
          ),
          const SizedBox(width: PaddingValuesManager.p10),
          Expanded(
            child: ElevatedButton(
                style: ThemeManager.getElevatedButtonThemeRisk().style,
                onPressed: () => ref
                    .read(productManagerNotifierProvider().notifier)
                    .removeProduct(product.productId),
                child: Text(context.strings.deleteProduct,
                    textAlign: TextAlign.center)),
          )
        ],
      );

  Widget getCustomerButtons(BuildContext context, WidgetRef ref) =>
      ElevatedButton(
          onPressed: product.inStock
              ? () async {
                  var amount = await amountDialog(context, product);
                  if (amount == null) {
                    return;
                  }
                  ref
                      .read(customerCartProvider.notifier)
                      .addToCart(product, amount);
                }
              : null,
          child: Text(product.inStock
              ? context.strings.addToCart
              : context.strings.notInStock));

  Future<int?> amountDialog(BuildContext context, Product product) async {
    final TextEditingController amountController = TextEditingController();
    String? errorText;
    return await showDialog<int>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(context.strings.amountOfProduct),
            content: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    if (int.parse(value) > 99 || int.parse(value) <= 0) {
                      errorText = context.strings.amountIsNotCorrect;
                    } else {
                      errorText = null;
                    }
                  });
                },
                decoration: InputDecoration(
                    helperText: "",
                    labelText: context.strings.amount,
                    hintText: context.strings.amount,
                    errorText: errorText)),
            actions: [
              TextButton(
                  onPressed: () {
                    var value = int.tryParse(amountController.value.text);
                    if (amountController.value.text.isEmpty ||
                        value == null ||
                        value <= 0 ||
                        value > 99) {
                      setState(() {
                        errorText = context.strings.amountIsNotCorrect;
                        return;
                      });
                    } else {
                      setState(() {
                        errorText = null;
                      });
                      context.router.maybePop<int>(
                          int.parse(amountController.value.text));
                    }
                  },
                  child: Text(context.strings.confirm))
            ],
          ),
        );
      },
    );
  }

  Widget price(BuildContext context) => TextIconWidget(
      icon: Icons.monetization_on,
      text: Text("${product.price.toString()} ${context.strings.sr}"));
}
