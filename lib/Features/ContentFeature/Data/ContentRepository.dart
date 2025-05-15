import 'dart:io';

import 'package:baha_platform/Features/ContentFeature/Data/CommentsRepository.dart';
import 'package:baha_platform/Features/ContentFeature/Domain/Content.dart';
import 'package:baha_platform/Features/ContentFeature/Domain/ContentPartialData.dart';
import 'package:baha_platform/Features/_SharedData/AbstractDataRepository.dart';
import 'package:baha_platform/Localization/LocalizationRepository.dart';
import 'package:baha_platform/utils/Enums.dart';
import 'package:baha_platform/utils/FirebaseConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Domain/Comment.dart';

class ContentRepository extends AbstractRepository {
  final Ref ref;
  final CommentsRepository commentsRepository;

  ContentRepository(this.ref, this.commentsRepository);

  Future<List<Content>> getContentByType(ContentType contentType) async {
    return (await firebaseFireStore
            .collection(FirebaseConstants.contentCollection)
            .where(ContentDTO.firebaseType, isEqualTo: contentType.toValue())
            .get())
        .docs
        .map((e) async {
          var contentDTO = ContentDTO.fromMap(e.data());
          var comments = await commentsRepository
              .getCommentsDTOsToComments(contentDTO.comments);
          return contentDTO.toContent(comments);
        })
        .toList()
        .wait;
  }

  Stream<Content> getContentByIdStream(String contentId) {
    return firebaseFireStore
        .collection(FirebaseConstants.contentCollection)
        .where(ContentDTO.firebaseId, isEqualTo: contentId)
        .snapshots()
        .asyncMap(
      (event) async {
        var doc = event.docs.first;
        var contentDTO = ContentDTO.fromMap(doc.data());
        var comments = await commentsRepository
            .getCommentsDTOsToComments(contentDTO.comments);
        return contentDTO.toContent(comments);
      },
    );
  }

  Stream<List<Content>> getContentByTypeStream(ContentType contentType) {
    return firebaseFireStore
        .collection(FirebaseConstants.contentCollection)
        .where(ContentDTO.firebaseType, isEqualTo: contentType.toValue())
        .snapshots()
        .asyncMap((event) => event.docs
            .map((e) async {
              var contentDTO = ContentDTO.fromMap(e.data());
              var comments = await commentsRepository
                  .getCommentsDTOsToComments(contentDTO.comments);
              return contentDTO.toContent(comments);
            })
            .toList()
            .wait);
  }

  Future<bool> addContent(ContentDTO contentDTO) async {
    var doc = await firebaseFireStore
        .collection(FirebaseConstants.contentCollection)
        .add(contentDTO.toMap());

    contentDTO = contentDTO.copyWith(id: doc.id);
    if (contentDTO.imagesURLs.isNotEmpty) {
      contentDTO = contentDTO.copyWith(
          imagesURLs: await addContentImages(
              contentId: doc.id, imagesPaths: contentDTO.imagesURLs));
    }
    contentDTO = await localizeContent(contentDTO);
    doc.update(contentDTO.toMap());
    return true;
  }

  Future<bool> updateContent(
      {required ContentDTO updatedContentDTO,
      required bool withUpdateImages}) async {
    if (withUpdateImages) {
      var newURLs = await addContentImages(
          contentId: updatedContentDTO.id,
          imagesPaths: updatedContentDTO.imagesURLs,
          withUpdate: withUpdateImages);
      updatedContentDTO = updatedContentDTO.copyWith(imagesURLs: newURLs);
    }
    updatedContentDTO = await localizeContent(updatedContentDTO);
    await _getContentDocumentById(updatedContentDTO.id).update(
        withUpdateImages ? updatedContentDTO.toMap() : updatedContentDTO.toMap()
          ..remove(ContentDTO.firebaseImagesURLs));

    return true;
  }

  Future<bool> deleteContent(String contentId) async {
    await deleteContentImages(contentId);
    await ref
        .read(repositoryClientProvider)
        .storiesRepository
        .deleteContentStories(contentId);
    await _getContentDocumentById(contentId).delete();
    return true;
  }

  Future<CommentDTO> addComment(
      String comment, String contentId, String userId) async {
    var commentDTO = CommentDTO(
        id: CommentDTO.constructId(userId),
        userId: userId,
        comment: comment,
        date: DateTime.now());
    await firebaseFireStore
        .collection(FirebaseConstants.contentCollection)
        .doc(contentId)
        .update({
      ContentDTO.firebaseComments: FieldValue.arrayUnion([commentDTO.toMap()])
    });
    return commentDTO;
  }

  Future<bool> removeComment(CommentDTO commentDTO, String contentId) async {
    await firebaseFireStore
        .collection(FirebaseConstants.contentCollection)
        .doc(contentId)
        .update({
      ContentDTO.firebaseComments: FieldValue.arrayRemove([commentDTO])
    });
    return true;
  }

  Future<ContentPartialData> getContentPartialData(String contentId) async {
    var content = ContentDTO.fromMap((await firebaseFireStore
            .collection(FirebaseConstants.contentCollection)
            .doc(contentId)
            .get())
        .data()!);

    return content.toContentPartialData();
  }

  Future<List<String>> addContentImages(
      {required String contentId,
      required List<String> imagesPaths,
      bool withUpdate = false}) async {
    var storageRef = firebaseStorage
        .ref()
        .child("${FirebaseConstants.contentStorage}/$contentId");

    await storageRef
        .listAll()
        .then((value) => value.items.forEach((element) async {
              await element.delete();
            }));

    List<UploadTask> tasks = [];
    for (int i = 0; i < imagesPaths.length; i++) {
      tasks.add(storageRef.child("$i").putFile(File(imagesPaths.elementAt(i))));
    }
    var res = await tasks.wait;
    var urls = res.map((e) => e.ref.getDownloadURL());
    if (withUpdate) {
      await _getContentDocumentById(contentId)
          .update({ContentDTO.firebaseImagesURLs: (await urls.wait)});
      return await urls.wait;
    }
    return await urls.wait;
  }

  Future<void> deleteContentImages(String contentId) async {
    await (await firebaseStorage
            .ref()
            .child("${FirebaseConstants.contentStorage}/$contentId/")
            .listAll())
        .items
        .map((e) => e.delete())
        .wait;
  }

  Future<ContentDTO> localizeContent(ContentDTO contentDTO) async {
    var locProvider = ref.read(localizationRepositoryProvider).requireValue;
    var localizedTitle = locProvider.localizeString(contentDTO.title);
    var localizedDescription =
        locProvider.localizeString(contentDTO.description);
    var localizedArea = locProvider.localizeString(contentDTO.area);
    var localizedFacilities =
        locProvider.localizeStringList(contentDTO.facilities);
    var localizedServices = locProvider.localizeStringList(contentDTO.services);
    contentDTO = contentDTO.copyWith(
        title: await localizedTitle,
        description: await localizedDescription,
        area: await localizedArea,
        facilities: await localizedFacilities,
        services: await localizedServices);
    return contentDTO;
  }

  DocumentReference<Map<String, dynamic>> _getContentDocumentById(
          String docId) =>
      firebaseFireStore
          .collection(FirebaseConstants.contentCollection)
          .doc(docId);

  Future<DocumentReference<Map<String, dynamic>>>
      _getContentDocumentByCreateContent(ContentDTO contentDTO) async =>
          await firebaseFireStore
              .collection(FirebaseConstants.contentCollection)
              .add(contentDTO.toMap());
}
