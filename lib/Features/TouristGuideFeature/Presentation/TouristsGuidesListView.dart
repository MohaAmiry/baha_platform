import 'package:auto_route/annotations.dart';
import 'package:baha_platform/Features/TouristGuideFeature/Presentation/_Widgets/TouristGuideInfoWidget.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/ValuesManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/Resouces/theme.dart';
import '../../SplashFeature/ErrorView.dart';
import '../../SplashFeature/LoadingView.dart';
import 'Notifiers/TouristGuidesProvider.dart';

@RoutePage()
class TouristsGuidesListView extends ConsumerWidget {
  const TouristsGuidesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.strings.touristGuides),
      ),
      body: Container(
        decoration: ThemeManager.scaffoldBackground,
        child: ref.watch(touristGuidesListProvider).when(
            data: (data) => ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(PaddingValuesManager.p10),
                    child: TouristGuideInfoWidget(
                        touristGuide: data.elementAt(index)),
                  ),
                ),
            error: (error, stackTrace) => ErrorView(error: error),
            loading: () => const LoadingView()),
      ),
    );
  }
}
