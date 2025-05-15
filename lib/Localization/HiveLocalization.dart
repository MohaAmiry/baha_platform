import 'dart:ui';

import 'package:hive/hive.dart';

part 'HiveLocalization.g.dart';

@HiveType(typeId: 0)
class HiveLocalization extends HiveObject {
  @HiveField(0)
  String language;
  @HiveField(1)
  String countryCode;

  HiveLocalization(this.language, this.countryCode);

  Locale toLocale() =>
      Locale.fromSubtags(languageCode: language, countryCode: countryCode);
}
