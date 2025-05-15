import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/Resouces/AssetsManager.dart';
import '../../../utils/Resouces/ValuesManager.dart';
import '../../../utils/Resouces/theme.dart';

@RoutePage()
class AboutApplicationView extends ConsumerWidget {
  const AboutApplicationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.strings.aboutApplication)),
      body: Container(
          height: double.infinity,
          decoration: ThemeManager.scaffoldBackground,
          child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: PaddingValuesManager.p20,
                  vertical: PaddingValuesManager.p20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: MediaQuery.sizeOf(context).height * .3,
                        child: Image.asset(ImageAssetsManager.logo)),
                    Text(context.strings.bahaGuide,
                        style: Theme.of(context).textTheme.titleLarge),
                    const Divider(),
                    Text(context.strings.whatIsThisApplicationTitle,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(context.strings.whatIsThisApplicationDescription),
                    const Divider(),
                    Text(
                        "${context.strings.contactTheDeveloperAt}: dlylalbaht@gmail.com"),
                    Text("${context.strings.version}: 1.0.0"),
                  ],
                ),
              ))),
    );
  }
}
