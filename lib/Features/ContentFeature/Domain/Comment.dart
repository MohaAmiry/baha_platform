import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserResponseDTO.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'Comment.mapper.dart';

@MappableClass()
class CommentDTO with CommentDTOMappable {
  final String id;
  final String userId;
  final String comment;
  final DateTime date;

  const CommentDTO(
      {required this.id,
      required this.userId,
      required this.comment,
      required this.date});

  static get firebaseId => "id";

  static get firebaseUserId => "userId";

  static get firebaseComment => "comment";

  static get firebaseDate => "date";

  static const fromMap = CommentDTOMapper.fromMap;

  Comment toComment(UserResponseDTO userInfo) =>
      Comment(id: id, userInfo: userInfo, comment: comment, date: date);

  static String constructId(String userId) =>
      "$userId${DateTime.now().millisecondsSinceEpoch}";
}

@MappableClass()
class Comment with CommentMappable {
  final String id;
  final UserResponseDTO userInfo;
  final String comment;
  final DateTime date;

  const Comment(
      {required this.id,
      required this.userInfo,
      required this.comment,
      required this.date});

  CommentDTO toDTO() =>
      CommentDTO(id: id, userId: userInfo.userId, comment: comment, date: date);
}
