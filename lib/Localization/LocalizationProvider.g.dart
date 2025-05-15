// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocalizationProvider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localizationHash() => r'1f99e43bc83df7dada7c4622b89cc06a0ed3ee4e';

/// See also [localization].
@ProviderFor(localization)
final localizationProvider = AutoDisposeProvider<AppLocalizations>.internal(
  localization,
  name: r'localizationProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$localizationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocalizationRef = AutoDisposeProviderRef<AppLocalizations>;
String _$availableLanguagesHash() =>
    r'14b675f52434e10f168576471aa837037b9ff60e';

/// See also [availableLanguages].
@ProviderFor(availableLanguages)
final availableLanguagesProvider = AutoDisposeProvider<List<Locale>>.internal(
  availableLanguages,
  name: r'availableLanguagesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableLanguagesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableLanguagesRef = AutoDisposeProviderRef<List<Locale>>;
String _$localizationControllerHash() =>
    r'f70896501df6c55d47799b9de21b80699c459229';

/// See also [LocalizationController].
@ProviderFor(LocalizationController)
final localizationControllerProvider =
    AsyncNotifierProvider<LocalizationController, Locale>.internal(
  LocalizationController.new,
  name: r'localizationControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localizationControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LocalizationController = AsyncNotifier<Locale>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
