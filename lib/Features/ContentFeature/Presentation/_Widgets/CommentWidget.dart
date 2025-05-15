import 'package:baha_platform/Features/AuthenticationFeature/Data/AuthController.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserRole.dart';
import 'package:baha_platform/Features/ContentFeature/Domain/Comment.dart';
import 'package:baha_platform/utils/Enums.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/ValuesManager.dart';
import 'package:baha_platform/utils/Resouces/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentWidget extends ConsumerWidget {
  final Comment comment;
  final VoidCallback removeFunc;

  const CommentWidget(
      {super.key, required this.comment, required this.removeFunc});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = comment.date.toTimeAgo();
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          CircleAvatar(
              foregroundImage: NetworkImage(comment.userInfo.personalImageURL)),
          Padding(
            padding: const EdgeInsets.all(PaddingValuesManager.p10),
            child: Text(comment.userInfo.name),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: switch (ref.watch(authControllerProvider).requireValue) {
                null => throw UnimplementedError(),
                Admin() => Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buildText(date, ref, context),
                      IconButton(
                          onPressed: () => removeFunc(),
                          icon: const Icon(Icons.highlight_remove_sharp),
                          visualDensity: VisualDensity.compact)
                    ],
                  ),
                Customer() => buildText(date, ref, context),
                Shop() => buildText(date, ref, context),
                TouristGuide() => buildText(date, ref, context)
              },
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.all(PaddingValuesManager.p10),
        child: Text(comment.comment),
      ),
    );
  }

  Widget buildText(({int numAgo, TimeType timeType}) date, WidgetRef ref,
          BuildContext context) =>
      Expanded(
        child: Row(
          children: [
            Text("${date.numAgo} ${ref.getLocalizedTimeType(date.timeType)}",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: ColorManager.secondary)),
          ],
        ),
      );
}
