import 'package:baha_platform/utils/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Localization/LocalizationProvider.dart';
import '../../utils/Resouces/ValuesManager.dart';
import '../../utils/Resouces/theme.dart';

class LanguagesList extends ConsumerWidget {
  const LanguagesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButton<Locale>(
        hint: Align(
            alignment: Alignment.centerLeft,
            child: Text(context.strings.language)),
        isExpanded: false,
        underline: Container(),
        alignment: Alignment.bottomCenter,
        elevation: 0,
        borderRadius: BorderRadius.circular(AppSizeManager.s10),
        value: ref.watch(localizationControllerProvider).requireValue,
        icon: const Icon(Icons.keyboard_arrow_down),
        style: Theme.of(context).textTheme.headlineMedium,
        isDense: true,
        menuMaxHeight: MediaQuery.sizeOf(context).height * 0.2,
        padding: const EdgeInsets.symmetric(
            horizontal: PaddingValuesManager.p10,
            vertical: PaddingValuesManager.p10),
        dropdownColor: ColorManager.secondaryFixedDim,
        items: ref
            .watch(availableLanguagesProvider)
            .map((e) => DropdownMenuItem<Locale>(
                value: e,
                child: Text(
                  e.translateLocaleName(),
                  style: Theme.of(context).textTheme.bodyMedium,
                )))
            .toList(),
        onChanged: (value) => ref
            .read(localizationControllerProvider.notifier)
            .setNewLocale(value));
  }
}
