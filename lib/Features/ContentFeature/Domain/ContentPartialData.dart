import 'package:baha_platform/utils/Enums.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../_SharedData/LocalizedString.dart';

part 'ContentPartialData.mapper.dart';

@MappableClass()
class ContentPartialData with ContentPartialDataMappable {
  final String contentId;
  final LocalizedString title;
  final LocalizedString area;
  final ContentType type;
  final String imagesURLs;

  ContentPartialData(
      {required this.contentId,
      required this.area,
      required this.title,
      required this.type,
      required this.imagesURLs});
}
