import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/ContentFeature/Presentation/Notifiers/ContentTypeTabNotifier.dart';
import 'package:baha_platform/Features/ContentFeature/Presentation/_Widgets/ContentOverviewWidget.dart';
import 'package:baha_platform/Features/SplashFeature/ErrorView.dart';
import 'package:baha_platform/Features/SplashFeature/LoadingView.dart';
import 'package:baha_platform/Localization/LocalizationRepository.dart';
import 'package:baha_platform/utils/Enums.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/AssetsManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/Resouces/theme.dart';

@RoutePage()
class ContentTypeView extends ConsumerWidget {
  final ContentType contentType;

  const ContentTypeView({super.key, required this.contentType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: ref.watch(contentTypeTabNotifierProvider(contentType)).when(
            data: (data) => CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      floating: true,
                      primary: true,
                      expandedHeight: 200.0,
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.pin,
                        background: Stack(
                          children: [
                            buildImage(),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 50.0,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.center,
                                    colors: [
                                      Colors.transparent,
                                      ColorManager.surface.withOpacity(1),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        centerTitle: true,
                        title: ClipRRect(
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Container(
                              width: double.infinity,
                              color: Colors.black.withOpacity(0.2),
                              child: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        ref.getLocalizedContentType(
                                            contentType),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    Text(
                                        ref
                                            .read(
                                                localizationRepositoryProvider)
                                            .requireValue
                                            .getContentTypeDescription(
                                                contentType),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                            childCount: data.length,
                            (context, index) => ContentOverviewWidget(
                                  content: data.elementAt(index),
                                ))),
                  ],
                ),
            error: (error, stackTrace) => ErrorView(error: error),
            loading: () => const LoadingView()));
  }

  Widget buildImage() => Image.asset(
        switch (contentType) {
          ContentType.forests => ImageAssetsManager.contentForestsBackground,
          ContentType.parks => ImageAssetsManager.contentParksBackground,
          ContentType.archaeologicalVillages =>
            ImageAssetsManager.contentArchaeologicalVillagesBackground,
          ContentType.farms => ImageAssetsManager.contentFarmsBackground,
          ContentType.hotels => ImageAssetsManager.contentHotelsBackground,
          ContentType.cafes => ImageAssetsManager.contentCafesBackground,
          ContentType.resorts => ImageAssetsManager.contentResortsBackground,
          ContentType.festivals =>
            ImageAssetsManager.contentFestivalsBackground,
        },
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
        height: double.infinity,
        width: double.infinity,
      );
}
