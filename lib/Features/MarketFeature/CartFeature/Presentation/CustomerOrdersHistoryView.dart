import 'package:auto_route/annotations.dart';
import 'package:baha_platform/Features/MarketFeature/CartFeature/Presentation/Notifiers/CustomerOrdersNotifiers.dart';
import 'package:baha_platform/Features/MarketFeature/CartFeature/Presentation/_Widgets/OrderOverviewWidget.dart';
import 'package:baha_platform/Features/SplashFeature/ErrorView.dart';
import 'package:baha_platform/Features/SplashFeature/LoadingView.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/Resouces/ValuesManager.dart';
import '../../../../utils/Resouces/theme.dart';

@RoutePage()
class CustomerOrdersHistoryView extends ConsumerWidget {
  const CustomerOrdersHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.strings.finishedOrders),
      ),
      body: Container(
        height: double.infinity,
        decoration: ThemeManager.scaffoldBackground,
        child: Padding(
          padding: const EdgeInsets.all(PaddingValuesManager.p20),
          child: ref.watch(customerOrdersHistoryProvider(true)).when(
                data: (data) => ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) =>
                      OrderOverviewWidget(order: data.elementAt(index)),
                ),
                error: (error, stackTrace) => ErrorView(error: error),
                loading: () => const LoadingView(),
              ),
        ),
      ),
    );
  }
}
