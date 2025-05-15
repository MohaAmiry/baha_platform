import 'package:baha_platform/utils/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/Resouces/ValuesManager.dart';
import '../../../../utils/Resouces/theme.dart';

class ContentEmergencyNumberWidget extends ConsumerWidget {
  final String number;
  final String text;

  const ContentEmergencyNumberWidget(
      {super.key, required this.number, required this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => Uri(scheme: "tel", path: number).launchPhoneCall(),
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        color: ColorManager.onSecondaryFixedVariant,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border(
              left: BorderSide(color: ColorManager.secondary, width: 5.0),
              right: BorderSide(color: ColorManager.secondary, width: 5.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(PaddingValuesManager.p5),
            child: Text("$text: $number"),
          ),
        ),
      ),
    );
  }
}
