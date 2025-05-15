import 'package:baha_platform/Features/_SharedData/LocalizedString.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/ValuesManager.dart';
import 'package:baha_platform/utils/Resouces/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContentServicesWidget extends ConsumerWidget {
  final LocalizedString string;
  final void Function()? isInEditFunc;

  const ContentServicesWidget(
      {super.key, required this.string, this.isInEditFunc});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
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
          child: isInEditFunc == null
              ? Text(ref.getLocalizedString(string))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ref.getLocalizedString(string)),
                    IconButton(
                        onPressed: isInEditFunc!,
                        icon: const Icon(Icons.remove))
                  ],
                ),
        ),
      ),
    );
  }
}
