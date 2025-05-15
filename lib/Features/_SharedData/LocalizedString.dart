import 'package:dart_mappable/dart_mappable.dart';

part 'LocalizedString.mapper.dart';

@MappableClass()
class LocalizedString with LocalizedStringMappable {
  final String en;
  final String ar;

  const LocalizedString({required this.en, required this.ar});

  factory LocalizedString.empty() => const LocalizedString(en: "", ar: "");
}
