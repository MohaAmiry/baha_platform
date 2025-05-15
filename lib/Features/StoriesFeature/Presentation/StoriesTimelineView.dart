import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/StoriesFeature/Domain/ContentStories.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/ValuesManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';

import '../../../utils/Resouces/theme.dart';

@RoutePage()
class StoriesTimelineView extends ConsumerStatefulWidget {
  final ContentStories stories;

  const StoriesTimelineView({super.key, required this.stories});

  @override
  ConsumerState createState() => _StoriesTimelineViewState();
}

class _StoriesTimelineViewState extends ConsumerState<StoriesTimelineView> {
  final FlutterStoryController controller = FlutterStoryController();
  String userName = "";
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    userName = widget.stories.stories.first.userName;
    dateTime = widget.stories.stories.first.recordDate;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyViewIndicatorConfig = StoryViewIndicatorConfig(
      height: 4,
      activeColor: Colors.white,
      backgroundCompletedColor: Colors.white,
      backgroundDisabledColor: Colors.white.withOpacity(0.5),
      horizontalGap: 1,
      borderRadius: 1.5,
    );

    final list = widget.stories.getStoriesItems();

    return FlutterStoryPresenter(
      flutterStoryController: controller,
      items: list,
      storyViewIndicatorConfig: storyViewIndicatorConfig,
      initialIndex: 0,
      headerWidget: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: PaddingValuesManager.p20,
              horizontal: PaddingValuesManager.p20),
          child: buildHeader(userName, dateTime),
        ),
      ),
      onStoryChanged: (index) {
        if (index == 0) return;
        setState(() {
          userName = widget.stories.stories.elementAt(index).userName;
          dateTime = widget.stories.stories.elementAt(index).recordDate;
        });
      },
      onCompleted: () async {
        context.router.maybePop();
      },
    );
  }

  Widget buildHeader(String userName, DateTime dateTime) {
    final timeAgo = dateTime.toTimeAgoStory();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("$userName", style: Theme.of(context).textTheme.titleSmall),
            Text(
                " ${timeAgo.numAgo} ${ref.getLocalizedStoryTimeType(timeAgo.storyTimeType)}",
                style: Theme.of(context).textTheme.titleSmall)
          ],
        ),
        Text(ref.getLocalizedString(widget.stories.contentTitle),
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: ColorManager.outline)),
        Text(ref.getLocalizedString(widget.stories.area),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: ColorManager.outline)),
      ],
    );
  }
}
