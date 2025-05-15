import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'LocalizationRepository.dart';

part 'LocalizationProvider.g.dart';

@riverpod
AppLocalizations localization(LocalizationRef ref) {
  // set the initial locale
  ref.state = lookupAppLocalizations(basicLocaleListResolution(
      [ref.watch(localizationControllerProvider).requireValue],
      AppLocalizations.supportedLocales));
  // update afterwards
  final observer = _LocaleObserver((locales) {
    ref.state = lookupAppLocalizations(basicLocaleListResolution(
        [ref.watch(localizationControllerProvider).requireValue],
        AppLocalizations.supportedLocales));
  });
  final binding = WidgetsBinding.instance;
  binding.addObserver(observer);
  ref.onDispose(() => binding.removeObserver(observer));
  return ref.state;
}

class _LocaleObserver extends WidgetsBindingObserver {
  _LocaleObserver(this._didChangeLocales);

  final void Function(List<Locale>? locales) _didChangeLocales;

  @override
  void didChangeLocales(List<Locale>? locales) {
    _didChangeLocales(locales);
  }
}

@Riverpod(keepAlive: true)
class LocalizationController extends _$LocalizationController {
  @override
  FutureOr<Locale> build() async {
    return ref.read(localizationRepositoryProvider).requireValue.getLocale();
  }

  Future<void> setNewLocale(Locale? locale) async {
    if (locale == null) return;
    if (state is! AsyncData) return;
    if (state.requireValue == locale) return;

    var result = await AsyncValue.guard(() async => await ref
        .read(localizationRepositoryProvider)
        .requireValue
        .setNewLocale(locale.languageCode, locale.countryCode ?? ""));
    if (result is! AsyncError) {
      state = AsyncData(await ref
          .read(localizationRepositoryProvider)
          .requireValue
          .getLocale());
    }
  }
}

@riverpod
List<Locale> availableLanguages(Ref ref) {
  return [
    const Locale('en', 'US'),
    const Locale('ar', 'AE'),
  ];
}
