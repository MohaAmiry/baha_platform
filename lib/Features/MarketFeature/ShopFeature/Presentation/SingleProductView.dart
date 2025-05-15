import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/MarketFeature/ShopFeature/Domain/Product.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/ValuesManager.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Router/MyRoutes.gr.dart';
import '../../../../utils/Resouces/theme.dart';
import '../../../AuthenticationFeature/Data/AuthController.dart';
import '../../../AuthenticationFeature/Domain/UserRole.dart';
import '../../../_SharedData/LocalizedString.dart';
import '../../CartFeature/Presentation/Notifiers/CartNotifiers.dart';
import 'Providers/ProductManagementNotifier.dart';

@RoutePage()
class SingleProductView extends ConsumerWidget {
  final Product product;

  const SingleProductView({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          buildAppBar(product.name, product.images, ref),
          SliverPadding(
            padding: const EdgeInsets.all(PaddingValuesManager.p20),
            sliver: SliverList.list(children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () => context.router.replace(
                        SingleShopRoute(shopOverview: product.shopOverview)),
                    child: Text(product.shopOverview.shopName,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: ColorManager.secondary))),
              ),
              const Divider(),
              Text(ref.getLocalizedString(product.description),
                  style: Theme.of(context).textTheme.headlineSmall),
              const Divider(),
              Text("${product.price.toStringAsFixed(2)} ${context.strings.sr}",
                  style: Theme.of(context).textTheme.headlineSmall),
              const Divider(),
              Text(
                  "${context.strings.product} ${ref.getLocalizedShopType(product.shopType)}",
                  style: Theme.of(context).textTheme.headlineSmall),
              const Divider(),
              Text(
                  product.inStock
                      ? context.strings.stocked
                      : context.strings.notInStock,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(
                height: AppSizeManager.s135,
              ),
              ref.watch(authControllerProvider).value is Shop
                  ? getShopButtons(context, ref)
                  : getCustomerButtons(context, ref)
            ]),
          )
        ],
      ),
    );
  }

  Widget buildAppBar(
          LocalizedString title, List<String> imagesURLs, WidgetRef ref) =>
      SliverAppBar(
        expandedHeight: 300.0,
        pinned: true,
        flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return FlexibleSpaceBar(
              centerTitle: true,
              title: Text(ref.getLocalizedString(title)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 300.0,
                      viewportFraction: 1.0,
                      autoPlay: true,
                      enlargeCenterPage: false,
                    ),
                    items: imagesURLs.map((url) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Image.network(
                            url,
                            fit: BoxFit.contain,
                            width: double.infinity,
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.transparent,
                            ColorManager.surface.withOpacity(1),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

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
}
