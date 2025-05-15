import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserRole.dart';
import 'package:baha_platform/Features/ContentFeature/Domain/ContentTime.dart';
import 'package:baha_platform/Features/_SharedData/LocalizedString.dart';
import 'package:baha_platform/Localization/HiveLocalization.dart';
import 'package:baha_platform/Localization/LocalizationProvider.dart';
import 'package:baha_platform/utils/Enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:translator/translator.dart';

part 'LocalizationRepository.g.dart';

const String _localizationBox = "LocalizationBox";
const String _currentLocale = "CurrentLocale";

@Riverpod(keepAlive: true)
Future<_LocalizationRepository> localizationRepository(Ref ref) async {
  final translator = GoogleTranslator();
  var repo = _LocalizationRepository(ref, translator);
  await repo.initLocalizationRepository();
  return _LocalizationRepository(ref, translator);
}

class _LocalizationRepository {
  final Ref ref;
  final GoogleTranslator translator;

  const _LocalizationRepository(this.ref, this.translator);

  Future<void> initLocalizationRepository() async {
    await Hive.initFlutter();
    var isRegistered = Hive.isAdapterRegistered(0);
    if (!isRegistered) {
      Hive.registerAdapter(HiveLocalizationAdapter());
    }
  }

  Future<Locale> getLocale() async {
    var box = await _getLocalizationBox();

    var currentLocale = box.get(_currentLocale);
    if (currentLocale != null) {
      return currentLocale.toLocale();
    }
    var defaultLang = ref.read(availableLanguagesProvider).first;
    await setNewLocale(defaultLang.languageCode, defaultLang.countryCode!);
    currentLocale = box.get(_currentLocale);
    box.close();
    return currentLocale!.toLocale();
  }

  Future<void> setNewLocale(String language, String countryCode) async =>
      await (await _getLocalizationBox())
          .put(_currentLocale, HiveLocalization(language, countryCode));

  String getContentTypeString(ContentType contentType) {
    return switch (contentType) {
      ContentType.forests => ref.read(localizationProvider).forests,
      ContentType.parks => ref.read(localizationProvider).parks,
      ContentType.archaeologicalVillages =>
        ref.read(localizationProvider).archaeologicalVillages,
      ContentType.farms => ref.read(localizationProvider).farms,
      ContentType.hotels => ref.read(localizationProvider).hotels,
      ContentType.cafes => ref.read(localizationProvider).cafes,
      ContentType.resorts => ref.read(localizationProvider).resorts,
      ContentType.festivals => ref.read(localizationProvider).festivals,
    };
  }

  String getLocalizedServiceProviderType(UserRoleEnum userRole) =>
      switch (userRole) {
        UserRoleEnum.admin => ref.read(localizationProvider).admin,
        UserRoleEnum.customer => ref.read(localizationProvider).customer,
        UserRoleEnum.shop => ref.read(localizationProvider).shop,
        UserRoleEnum.touristGuide =>
          ref.read(localizationProvider).touristGuide,
      };

  String getLocalizedDay(Day day) => switch (day) {
        Day.saturday => ref.read(localizationProvider).saturday,
        Day.sunday => ref.read(localizationProvider).sunday,
        Day.monday => ref.read(localizationProvider).monday,
        Day.tuesday => ref.read(localizationProvider).tuesday,
        Day.wednesday => ref.read(localizationProvider).wednesday,
        Day.thursday => ref.read(localizationProvider).thursday,
        Day.friday => ref.read(localizationProvider).friday,
      };

  String getLocalizedTimeType(TimeType timeType) => switch (timeType) {
        TimeType.days => ref.read(localizationProvider).d,
        TimeType.months => ref.read(localizationProvider).m,
        TimeType.years => ref.read(localizationProvider).y,
      };

  String getLocalizedShopType(ShopTypeEnum shopType) => switch (shopType) {
        ShopTypeEnum.productiveFamilyShop =>
          ref.read(localizationProvider).productiveFamilyShop,
        ShopTypeEnum.agriculturalShop =>
          ref.read(localizationProvider).agriculturalShop,
        ShopTypeEnum.artisanShop => ref.read(localizationProvider).artisanShop,
      };

  String getLocalizedProductsType(ShopTypeEnum shopType) => switch (shopType) {
        ShopTypeEnum.productiveFamilyShop =>
          ref.read(localizationProvider).productiveFamilies,
        ShopTypeEnum.agriculturalShop =>
          ref.read(localizationProvider).agricultural,
        ShopTypeEnum.artisanShop => ref.read(localizationProvider).artisan,
      };

  String getLocalizedStoryTimeType(StoryTimeType timeType) =>
      switch (timeType) {
        StoryTimeType.second => ref.read(localizationProvider).seconds,
        StoryTimeType.minute => ref.read(localizationProvider).minutes,
        StoryTimeType.hour => ref.read(localizationProvider).hours,
      };

  String getLocalizedOrderState(bool? state) => switch (state) {
        null => ref.read(localizationProvider).pending,
        true => ref.read(localizationProvider).accepted,
        false => ref.read(localizationProvider).rejected,
      };

  String getContentTypeDescription(ContentType contentType) =>
      switch (contentType) {
        ContentType.forests =>
          ref.read(localizationProvider).forestsDescription,
        ContentType.parks => ref.read(localizationProvider).parksDescription,
        ContentType.archaeologicalVillages =>
          ref.read(localizationProvider).archaeologicalVillagesDescription,
        ContentType.farms => ref.read(localizationProvider).farmsDescription,
        ContentType.hotels => ref.read(localizationProvider).hotelsDescription,
        ContentType.cafes => ref.read(localizationProvider).cafesDescription,
        ContentType.resorts =>
          ref.read(localizationProvider).resortsDescription,
        ContentType.festivals =>
          ref.read(localizationProvider).festivalsDescription,
      };

  Future<LocalizedString> localizeString(LocalizedString text) async {
    if (text.ar.isEmpty) return text;
    var result = await translator.translate(text.ar);
    return LocalizedString(en: result.text, ar: text.ar);
  }

  Future<List<LocalizedString>> localizeStringList(
      List<LocalizedString> texts) async {
    return (await texts.map((e) => localizeString(e)).wait).toList();
  }

  // internal functions
  static Future<Box<HiveLocalization>> _getLocalizationBox() async =>
      await Hive.openBox<HiveLocalization>(_localizationBox);
}
