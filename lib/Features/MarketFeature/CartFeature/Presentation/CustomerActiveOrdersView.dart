import 'package:auto_route/annotations.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/Resouces/ValuesManager.dart';
import '../../../../utils/Resouces/theme.dart';
import '../../../SplashFeature/ErrorView.dart';
import '../../../SplashFeature/LoadingView.dart';
import 'Notifiers/CustomerOrdersNotifiers.dart';
import '_Widgets/OrderOverviewWidget.dart';

@RoutePage()
class CustomerActiveOrdersView extends ConsumerWidget {
  const CustomerActiveOrdersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.strings.activeOrders),
      ),
      body: Container(
        height: double.infinity,
        decoration: ThemeManager.scaffoldBackground,
        child: Padding(
          padding: const EdgeInsets.all(PaddingValuesManager.p20),
          child: ref.watch(customerOrdersHistoryProvider(false)).when(
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
