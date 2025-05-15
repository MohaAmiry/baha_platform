import 'package:baha_platform/Features/_SharedData/AbstractDataRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../Domain/ContentStories.dart';

part 'StoriesNotifier.g.dart';

@riverpod
Stream<List<ContentStories>> contentStories(Ref ref) {
  return ref
      .read(repositoryClientProvider)
      .storiesRepository
      .getContentStories();
}
