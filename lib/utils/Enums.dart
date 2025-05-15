import 'package:dart_mappable/dart_mappable.dart';

part 'Enums.mapper.dart';

@MappableEnum()
enum ContentType {
  forests,
  parks,
  archaeologicalVillages,
  farms,
  hotels,
  cafes,
  resorts,
  festivals
}

@MappableEnum()
enum TimeType { days, months, years }

@MappableEnum()
enum StoryTimeType { second, minute, hour }

@MappableEnum()
enum TimeUnit { am, pm }
