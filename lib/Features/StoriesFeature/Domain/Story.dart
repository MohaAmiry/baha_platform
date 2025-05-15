import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'Story.mapper.dart';

@MappableClass()
class StoryDTO with StoryDTOMappable {
  final String storyId;
  final String userId;
  final String storyURL;
  final bool isVideo;
  final Timestamp recordDate;

  const StoryDTO(
      {required this.storyId,
      required this.userId,
      required this.storyURL,
      required this.isVideo,
      required this.recordDate});

  static String buildStoryId(String userId) =>
      "$userId${DateTime.now().millisecondsSinceEpoch}";

  Story toStory(String userName) => Story(
      storyId: storyId,
      userName: userName,
      storyURL: storyURL,
      isVideo: isVideo,
      recordDate: recordDate.toDate());
}

@MappableClass()
class Story with StoryMappable {
  final String storyId;
  final String userName;
  final String storyURL;
  final bool isVideo;
  final DateTime recordDate;

  const Story(
      {required this.storyId,
      required this.userName,
      required this.storyURL,
      required this.isVideo,
      required this.recordDate});
}
