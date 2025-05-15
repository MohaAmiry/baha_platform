import 'package:baha_platform/Features/_SharedData/AbstractDataRepository.dart';
import 'package:baha_platform/utils/FirebaseConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Domain/Comment.dart';
import '../Domain/Content.dart';

class CommentsRepository extends AbstractRepository {
  final Ref ref;

  CommentsRepository(this.ref);

  Future<List<Comment>> getCommentsDTOsToComments(
      List<CommentDTO> commentsDTOs) async {
    var users = (await commentsDTOs
        .map((e) => ref
            .read(repositoryClientProvider)
            .authRepository
            .getUserInfoById(e.userId))
        .wait);
    return commentsDTOs
        .mapIndexedAndLast(
            (index, item, isLast) => item.toComment(users.elementAt(index)))
        .toList();
  }

  Future<bool> addComment(CommentDTO commentDTO, String contentId) async {
    firebaseFireStore
        .collection(FirebaseConstants.contentCollection)
        .doc(contentId)
        .update({
      ContentDTO.firebaseComments: FieldValue.arrayUnion([commentDTO.toMap()])
    });
    return true;
  }

  Future<bool> deleteComment(CommentDTO comment, String contentId) async {
    await firebaseFireStore
        .collection(FirebaseConstants.contentCollection)
        .doc(contentId)
        .update({
      ContentDTO.firebaseComments: FieldValue.arrayRemove([comment.toMap()])
    });
    return true;
  }
}
