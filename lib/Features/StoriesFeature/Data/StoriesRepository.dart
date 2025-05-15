import 'dart:io';

import 'package:baha_platform/Features/StoriesFeature/Domain/ContentStories.dart';
import 'package:baha_platform/Features/_SharedData/AbstractDataRepository.dart';
import 'package:baha_platform/utils/Enums.dart';
import 'package:baha_platform/utils/FirebaseConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Domain/Story.dart';

class StoriesRepository extends AbstractRepository {
  final Ref ref;

  StoriesRepository(this.ref);

  Stream<List<ContentStories>> getContentStories() {
    return firebaseFireStore
        .collection(FirebaseConstants.storiesCollection)
        .where(ContentStoriesDTO.firebaseLatestStoryDate,
            isGreaterThan: Timestamp.fromDate(
                DateTime.now().subtract(const Duration(days: 1))))
        .snapshots()
        .asyncMap((event) async => await event.docs
            .map((doc) => ContentStoriesDTO.fromMap(doc.data()))
            .map((contentStoriesDTO) => toContentStory(contentStoriesDTO))
            .toList()
            .wait);
  }

  Future<ContentStories> toContentStory(
      ContentStoriesDTO contentStoriesDTO) async {
    final now = DateTime.now();
    final contentPartialData = ref
        .read(repositoryClientProvider)
        .contentRepository
        .getContentPartialData(contentStoriesDTO.contentId);
    final stories = contentStoriesDTO.stories
        .toIList()
        .sortOrdered(
            (a, b) => b.recordDate.seconds.compareTo(a.recordDate.seconds))
        .where(
            (story) => now.difference(story.recordDate.toDate()).inHours < 24)
        .map((e) => toStory(e))
        .wait;
    return contentStoriesDTO.toContentStories(
        await contentPartialData, await stories);
  }

  Future<Story> toStory(StoryDTO storyDTO) async {
    var userName = await ref
        .read(repositoryClientProvider)
        .authRepository
        .getUserNameById(storyDTO.userId);
    return storyDTO.toStory(userName);
  }

  Future<DocumentReference<Map<String, dynamic>>> addContentStories(
      ContentStoriesDTO contentStories) async {
    var doc = firebaseFireStore
        .collection(FirebaseConstants.storiesCollection)
        .doc(contentStories.contentId);
    await doc.set(contentStories.toMap());
    return doc;
  }

  Future<void> publishStory(
      StoryDTO storyDTO, String contentId, ContentType contentType) async {
    var doc = await firebaseFireStore
        .collection(FirebaseConstants.storiesCollection)
        .doc(contentId)
        .get();
    var storyURL = await uploadStory(storyDTO, contentId);
    storyDTO = storyDTO.copyWith(storyURL: storyURL);

    if (doc.exists) {
      await doc.reference.update({
        ContentStoriesDTO.firebaseLatestStoryDate: storyDTO.recordDate,
        ContentStoriesDTO.firebaseStories:
            FieldValue.arrayUnion([storyDTO.toMap()])
      });
      return;
    }
    await addContentStories(ContentStoriesDTO(
        contentId: contentId,
        stories: [storyDTO],
        latestStoryDate: storyDTO.recordDate));
    return;
  }

  Future<void> deleteContentStories(String contentId) async {
    await firebaseFireStore
        .collection(FirebaseConstants.storiesCollection)
        .doc(contentId)
        .delete();
    var storageRef = firebaseStorage
        .ref()
        .child("${FirebaseConstants.storiesStorage}/$contentId");
    await (await storageRef.listAll()).items.map((e) => e.delete()).wait;
  }

  Future<String> uploadStory(StoryDTO story, String contentId) async {
    var storageRef = firebaseStorage
        .ref()
        .child("${FirebaseConstants.storiesStorage}/$contentId");

    var task =
        await storageRef.child(story.storyId).putFile(File(story.storyURL));
    return await task.ref.getDownloadURL();
  }
}
