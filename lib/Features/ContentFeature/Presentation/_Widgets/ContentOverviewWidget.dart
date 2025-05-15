import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/ContentFeature/Domain/Content.dart';
import 'package:baha_platform/Features/_SharedData/TextIcon.dart';
import 'package:baha_platform/Router/MyRoutes.gr.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/ValuesManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/Resouces/AssetsManager.dart';
import '../../../../utils/Resouces/theme.dart';

class ContentOverviewWidget extends ConsumerWidget {
  final Content content;

  const ContentOverviewWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizeManager.s10),
      ),
      child: InkWell(
        onTap: () => context.router.push(ContentRoute(contentId: content.id)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Center(
                  child: Image.network(
                    content.imagesURLs.first,
                    fit: BoxFit.cover,
                    height: MediaQuery.sizeOf(context).height * 0.3,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        color: Colors.black.withOpacity(0.2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Text(ref.getLocalizedString(content.title),
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(PaddingValuesManager.p10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ref.getLocalizedString(content.description),
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextIconWidget(
                          icon: Icons.location_on,
                          text: Text(
                            ref.getLocalizedString(content.area),
                          ),
                        ),
                        IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () =>
                                Uri.parse(content.areaURL).launch(),
                            icon: const Icon(IconsAssetsManager.addressURLOnMap,
                                color: ColorManager.primary))
                      ],
                    ),
                  ),
                  if (content.contentDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextIconWidget(
                        icon: Icons.date_range,
                        text: Text(
                          content.contentDate!.toRegularDate(),
                          style: Theme.of(context).textTheme.labelMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
