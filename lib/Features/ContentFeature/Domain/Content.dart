import 'package:baha_platform/Features/ContentFeature/Domain/ContentPartialData.dart';
import 'package:baha_platform/Features/ContentFeature/Domain/ContentTime.dart';
import 'package:baha_platform/Features/_SharedData/LocalizedString.dart';
import 'package:baha_platform/utils/Enums.dart';
import 'package:dart_mappable/dart_mappable.dart';

import 'Comment.dart';

part 'Content.mapper.dart';

@MappableClass()
class ContentDTO with ContentDTOMappable {
  final String id;
  final LocalizedString title;
  final ContentType type;
  final LocalizedString description;
  final List<String> imagesURLs;
  final LocalizedString area;
  final String areaURL;
  final List<LocalizedString> services;
  final List<LocalizedString> facilities;
  final ContentTime? contentTime;
  final double? distanceFromCenter;
  final DateTime? contentDate;
  final List<CommentDTO> comments;

  static get firebaseId => "id";

  static get firebaseType => "type";

  static get firebaseDescription => "description";

  static get firebaseImagesURLs => "imagesURLs";

  static get firebaseArea => "area";

  static get firebaseServices => "services";

  static get firebaseFacilities => "facilities";

  static get firebaseContentDate => "contentDate";

  static get firebaseComments => "comments";

  static get firebaseDistanceFromCenter => "distanceFromCenter";

  const ContentDTO(
      {required this.id,
      required this.type,
      required this.title,
      required this.description,
      required this.imagesURLs,
      required this.area,
      required this.areaURL,
      required this.comments,
      required this.services,
      required this.facilities,
      required this.contentTime,
      required this.distanceFromCenter,
      required this.contentDate});

  factory ContentDTO.empty() => ContentDTO(
      distanceFromCenter: null,
      contentTime: null,
      contentDate: null,
      id: "",
      type: ContentType.archaeologicalVillages,
      title: LocalizedString.empty(),
      description: LocalizedString.empty(),
      imagesURLs: [],
      facilities: [],
      services: [],
      area: LocalizedString.empty(),
      areaURL: "",
      comments: []);

  static const fromMap = ContentDTOMapper.fromMap;

  ContentPartialData toContentPartialData() => ContentPartialData(
      area: area,
      contentId: id,
      title: title,
      type: type,
      imagesURLs: imagesURLs.first);

  Content toContent(List<Comment> comments) => Content(
      contentDate: contentDate,
      contentTime: contentTime,
      distanceFromCenter: distanceFromCenter,
      id: id,
      title: title,
      type: type,
      description: description,
      areaURL: areaURL,
      imagesURLs: imagesURLs,
      area: area,
      facilities: facilities,
      services: services,
      comments: comments);
}

@MappableClass()
class Content with ContentMappable {
  final String id;
  final LocalizedString title;
  final ContentType type;
  final LocalizedString description;
  final List<String> imagesURLs;
  final LocalizedString area;
  final String areaURL;
  final List<LocalizedString> services;
  final List<LocalizedString> facilities;
  final double? distanceFromCenter;
  final DateTime? contentDate;
  final ContentTime? contentTime;
  final List<Comment> comments;

  const Content(
      {required this.id,
      required this.type,
      required this.title,
      required this.description,
      required this.imagesURLs,
      required this.area,
      required this.areaURL,
      required this.comments,
      required this.services,
      required this.facilities,
      this.contentTime,
      this.distanceFromCenter,
      this.contentDate});

  static const fromMap = ContentMapper.fromMap;

  ContentDTO toDTO() => ContentDTO(
      id: id,
      title: title,
      type: type,
      description: description,
      imagesURLs: imagesURLs,
      areaURL: areaURL,
      area: area,
      services: services,
      facilities: facilities,
      contentTime: contentTime,
      contentDate: contentDate,
      distanceFromCenter: distanceFromCenter,
      comments: comments.map((e) => e.toDTO()).toList());
}
