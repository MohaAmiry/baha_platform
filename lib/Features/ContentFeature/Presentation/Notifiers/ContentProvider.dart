import 'package:baha_platform/Features/_SharedData/AbstractDataRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../Domain/Content.dart';

part 'ContentProvider.g.dart';

@riverpod
Stream<Content> getContentById(Ref ref, String contentId) {
  return ref
      .read(repositoryClientProvider)
      .contentRepository
      .getContentByIdStream(contentId);
}
