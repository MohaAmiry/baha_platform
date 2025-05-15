import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Router/MyRoutes.gr.dart';
import '../../utils/Resouces/AssetsManager.dart';
import '../../utils/Resouces/ValuesManager.dart';

class AboutAppWidget extends ConsumerWidget {
  const AboutAppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        TextButton(
            onPressed: () => context.router.push(const AboutApplicationRoute()),
            child: Text(context.strings.aboutApplication)),
        SizedBox(
            height: AppSizeManager.s90,
            child: Image.asset(ImageAssetsManager.logo))
      ],
    );
  }
}
