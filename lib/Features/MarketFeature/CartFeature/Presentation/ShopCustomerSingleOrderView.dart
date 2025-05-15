import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Data/AuthController.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserRole.dart';
import 'package:baha_platform/Features/MarketFeature/CartFeature/Domain/Order.dart';
import 'package:baha_platform/Features/MarketFeature/CartFeature/Presentation/Notifiers/OrdersNotifiers.dart';
import 'package:baha_platform/Features/MarketFeature/CartFeature/Presentation/_Widgets/OrderProductWidget.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/Resouces/ValuesManager.dart';
import '../../../../utils/Resouces/theme.dart';

@RoutePage()
class ShopCustomerSingleOrderView extends ConsumerWidget {
  final Order order;

  const ShopCustomerSingleOrderView({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.strings.orderDetails),
      ),
      body: Container(
        height: double.infinity,
        decoration: ThemeManager.scaffoldBackground,
        child: Padding(
          padding: const EdgeInsets.all(PaddingValuesManager.p20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: order.products.length,
                  itemBuilder: (context, index) => OrderProductWidget(
                      cartProduct: order.products.elementAt(index)),
                ),
                const Divider(),
                getSummary(context, ref),
                const SizedBox(
                  height: 20,
                ),
                if (ref
                            .watch(authControllerProvider)
                            .requireValue
                            .runtimeType ==
                        Shop &&
                    order.state == null)
                  Column(
                    children: [
                      getContactInfo(ref, context),
                      getShopButtons(ref, context)
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getSummary(BuildContext context, WidgetRef ref) => Card(
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
                "${context.strings.orderState}:${ref.getLocalizedOrderState(order.state)}"),
            Text(
              "${context.strings.orderProductsAmount}:${order.products.length}",
            ),
            Text(
                "${context.strings.total}: ${order.totalRaw} ${context.strings.sr}",
                style: Theme.of(context).textTheme.bodyMedium)
          ]),
        ),
      ));

  Widget getContactInfo(WidgetRef ref, BuildContext context) => Card(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("بيانات تواصل الزبون",
                    style: Theme.of(context).textTheme.titleLarge),
                const Divider(),
                Text("اسم الزبون: ${order.customerInfo.name}"),
                Text("رقم التواصل: ${order.customerInfo.phoneNumber}"),
                Text("الموقع: ${order.customerInfo.addressString}"),
                Text("وسيلة الاستلام: ${order.deliveryString}"),
              ],
            ),
          ),
        ),
      );

  Widget getShopButtons(WidgetRef ref, BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        ElevatedButton(
            onPressed: () async {
              var result = await ref
                  .read(shopCustomerOrdersProvider.notifier)
                  .setOrderState(true, order);
              if (result && context.mounted) {
                context.router.maybePop();
              }
            },
            child: const Text("قبول الطلب")),
        ElevatedButton(
            onPressed: () async {
              var result = await ref
                  .read(shopCustomerOrdersProvider.notifier)
                  .setOrderState(false, order);
              if (result && context.mounted) {
                context.router.maybePop();
              }
            },
            //style: ThemeManager.getElevatedButtonThemeRisk().style,
            child: const Text("رفض الطلب"))
      ]);
}
