import 'package:baha_platform/Features/ContentFeature/Domain/ContentPartialData.dart';
import 'package:baha_platform/Features/StoriesFeature/Domain/Story.dart';
import 'package:baha_platform/Features/_SharedData/LocalizedString.dart';
import 'package:baha_platform/utils/Enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';

part 'ContentStories.mapper.dart';

class TimestampMapper extends SimpleMapper<Timestamp> {
  @override
  Timestamp decode(Object value) {
    return value is String
        ? Timestamp.fromDate(DateTime.parse(value))
        : throw Exception("sssssssssssssssssssssssssss");
  }

  @override
  Object? encode(Timestamp self) {
    return self;
  }

  const TimestampMapper();
}

@MappableClass(includeCustomMappers: [TimestampMapper()])
class ContentStoriesDTO with ContentStoriesDTOMappable {
  final String contentId;
  final Timestamp latestStoryDate;
  final List<StoryDTO> stories;

  const ContentStoriesDTO(
      {required this.contentId,
      required this.stories,
      required this.latestStoryDate});

  static const fromMap = ContentStoriesDTOMapper.fromMap;

  static get firebaseLatestStoryDate => "latestStoryDate";

  static get firebaseStories => "stories";

  ContentStories toContentStories(
          ContentPartialData contentPartialData, List<Story> stories) =>
      ContentStories(
          contentId: contentId,
          area: contentPartialData.area,
          contentTitle: contentPartialData.title,
          contentType: contentPartialData.type,
          previewImageURL: contentPartialData.imagesURLs,
          stories: stories);
}

@MappableClass()
class ContentStories with ContentStoriesMappable {
  final String contentId;
  final LocalizedString contentTitle;
  final LocalizedString area;
  final ContentType contentType;
  final String previewImageURL;
  final List<Story> stories;

  const ContentStories(
      {required this.contentId,
      required this.area,
      required this.contentTitle,
      required this.contentType,
      required this.previewImageURL,
      required this.stories});

  List<StoryItem> getStoriesItems() => stories
      .map(
        (e) => StoryItem(
            storyItemType:
                e.isVideo ? StoryItemType.video : StoryItemType.image,
            url: e.storyURL,
            videoConfig: const StoryViewVideoConfig(
                fit: BoxFit.contain, useVideoAspectRatio: true)),
      )
      .toList();
}
