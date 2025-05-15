import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/MarketFeature/CartFeature/Presentation/Notifiers/OrdersNotifiers.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/Resouces/ValuesManager.dart';
import '../../../../utils/Resouces/theme.dart';
import '../../../SplashFeature/ErrorView.dart';
import '../../../SplashFeature/LoadingView.dart';
import '_Widgets/OrderOverviewWidget.dart';

@RoutePage()
class ShopOrdersHistoryView extends ConsumerWidget {
  const ShopOrdersHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.strings.customersOrdersHistory),
      ),
      body: Container(
        height: double.infinity,
        decoration: ThemeManager.scaffoldBackground,
        child: Padding(
            padding: const EdgeInsets.all(PaddingValuesManager.p20),
            child: ref.watch(shopCustomerOrdersHistoryProvider).when(
                data: (data) => ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) =>
                        OrderOverviewWidget(order: data.elementAt(index))),
                error: (error, stackTrace) => ErrorView(error: error),
                loading: () => const LoadingView())),
      ),
    );
  }
}
