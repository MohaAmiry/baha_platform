import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/StoriesFeature/Domain/ContentStories.dart';
import 'package:baha_platform/Router/MyRoutes.gr.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryOverviewWidget extends ConsumerWidget {
  final ContentStories group;

  const StoryOverviewWidget({super.key, required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.router.push(StoriesTimelineRoute(stories: group)),
      child: SizedBox(
        width: 90.0,
        height: 70.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 70.0,
                  height: 70.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.pink, Colors.orange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Container(
                  width: 64.0,
                  height: 64.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(group.previewImageURL),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              ref.getLocalizedString(group.contentTitle),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
