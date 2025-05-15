import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/SplashFeature/ErrorView.dart';
import 'package:baha_platform/Features/SplashFeature/LoadingView.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/Resouces/ValuesManager.dart';
import '../../../../utils/Resouces/theme.dart';
import '../Domain/Cart.dart';
import 'Notifiers/CartNotifiers.dart';
import '_Widgets/CartShopWidget.dart';

@RoutePage()
class CartView extends ConsumerWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.strings.cart),
      ),
      body: Container(
        decoration: ThemeManager.scaffoldBackground,
        child: Padding(
          padding: const EdgeInsets.all(PaddingValuesManager.p20),
          child: ref.watch(customerCartProvider).when(
                data: (data) => SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => const Divider(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => CartShopWidget(
                          cartShop: data.cartShops.elementAt(index),
                        ),
                        itemCount: data.cartShops.length,
                      ),
                      getSummary(context, data),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              var result = await ref
                                  .read(customerCartProvider.notifier)
                                  .confirmCart();
                              if (result && context.mounted) {
                                context.router.maybePop();
                              }
                            },
                            child: Text(context.strings.confirm)),
                      ),
                      const SizedBox(height: 25)
                    ],
                  ),
                ),
                error: (error, stackTrace) => ErrorView(error: error),
                loading: () => const LoadingView(),
              ),
        ),
      ),
    );
  }

  Widget getSummary(BuildContext context, Cart cart) => Card(
          child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              context.strings.summary,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
                "${context.strings.total}: ${cart.totalRaw} ${context.strings.sr}",
                style: Theme.of(context).textTheme.bodyMedium)
          ]),
        ),
      ));
}
