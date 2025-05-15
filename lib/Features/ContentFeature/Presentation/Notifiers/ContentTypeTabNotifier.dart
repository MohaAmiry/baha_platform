import 'package:baha_platform/Features/ContentFeature/Domain/Content.dart';
import 'package:baha_platform/Features/_SharedData/AbstractDataRepository.dart';
import 'package:baha_platform/utils/Enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ContentTypeTabNotifier.g.dart';

@riverpod
Stream<List<Content>> contentTypeTabNotifier(Ref ref, ContentType type) {
  return ref
      .read(repositoryClientProvider)
      .contentRepository
      .getContentByTypeStream(type);
}
