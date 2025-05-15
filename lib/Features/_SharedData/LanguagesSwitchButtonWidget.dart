import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Localization/LocalizationProvider.dart';
import '../../utils/Resouces/ValuesManager.dart';

class LanguagesSwitchButtonWidget extends ConsumerWidget {
  const LanguagesSwitchButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableLocales = ref.watch(availableLanguagesProvider);
    final locale = ref.watch(localizationControllerProvider).requireValue;
    final isArabic = locale.languageCode == 'ar';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.strings.arabicEnglish,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: ColorManager.secondary),
        ),
        const SizedBox(width: PaddingValuesManager.p10),
        Switch(
          value: isArabic,
          activeColor: ColorManager.primary,
          // Ensuring identical color for both sides
          inactiveThumbColor: ColorManager.primary,
          // Keeps the thumb color the same
          inactiveTrackColor: Colors.grey.shade300,
          activeTrackColor: Colors.grey.shade300,
          onChanged: (isArabic) {
            final newLocale =
                isArabic ? availableLocales[1] : availableLocales[0];
            ref
                .read(localizationControllerProvider.notifier)
                .setNewLocale(newLocale);
          },
        ),
      ],
    );
  }
}
