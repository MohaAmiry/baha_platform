import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Data/AuthController.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserRole.dart';
import 'package:baha_platform/Features/StoriesFeature/Presentation/Notifiers/StoriesNotifier.dart';
import 'package:baha_platform/Features/StoriesFeature/Presentation/StoryOverviewWidget.dart';
import 'package:baha_platform/Features/_SharedData/AbstractDrawer.dart';
import 'package:baha_platform/Localization/LocalizationRepository.dart';
import 'package:baha_platform/Router/MyRoutes.gr.dart';
import 'package:baha_platform/utils/Enums.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ExceptionHandler/MessageController.dart';
import '../../../ExceptionHandler/MessageEmitter.dart';

@RoutePage()
class AllContentTypesView extends ConsumerWidget {
  const AllContentTypesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(authControllerProvider).value.runtimeType == Customer) {
      ref
        ..listen<AsyncValue<UserRole?>>(authControllerProvider,
            (previous, next) {
          next.whenData((data) {
            if (data == null) {
              return context.router.replaceAll([const LoginRoute()]);
            }
          });
        })
        ..listen(messageEmitterProvider, (previous, next) {
          next != null
              ? ref
                  .read(MessageControllerProvider(context).notifier)
                  .showToast(next)
              : null;
        });
    }

    return AutoTabsRouter.tabBar(
      routes: [
        ContentTypeRoute(contentType: ContentType.archaeologicalVillages),
        ContentTypeRoute(contentType: ContentType.cafes),
        ContentTypeRoute(contentType: ContentType.resorts),
        ContentTypeRoute(contentType: ContentType.farms),
        ContentTypeRoute(contentType: ContentType.festivals),
        ContentTypeRoute(contentType: ContentType.forests),
        ContentTypeRoute(contentType: ContentType.hotels),
        ContentTypeRoute(contentType: ContentType.parks)
      ],
      builder: (context, child, tabController) {
        return Scaffold(
            appBar: AppBar(),
            drawer:
                ref.watch(authControllerProvider).value.runtimeType == Customer
                    ? const AbstractDrawer(userRoleEnum: UserRoleEnum.customer)
                    : null,
            body: ExtendedNestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      expandedHeight: 160,
                      floating: true,
                      pinned: true,
                      bottom: TabBar(
                        padding: EdgeInsets.zero,
                        isScrollable: true,
                        indicatorPadding: EdgeInsets.zero,
                        controller: tabController,
                        tabs: [
                          buildTab(ContentType.archaeologicalVillages, ref),
                          buildTab(ContentType.cafes, ref),
                          buildTab(ContentType.resorts, ref),
                          buildTab(ContentType.farms, ref),
                          buildTab(ContentType.festivals, ref),
                          buildTab(ContentType.forests, ref),
                          buildTab(ContentType.hotels, ref),
                          buildTab(ContentType.parks, ref),
                        ],
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                          background: ref.watch(contentStoriesProvider).when(
                                data: (data) => ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: StoryOverviewWidget(
                                          group: data.elementAt(index))),
                                  scrollDirection: Axis.horizontal,
                                ),
                                error: (error, stackTrace) =>
                                    Text(error.toString()),
                                loading: () => Container(),
                              )),
                    ),
                  ];
                },
                body: child));
      },
    );
  }

  Tab buildTab(ContentType contentType, WidgetRef ref) => Tab(
      text: ref
          .watch(localizationRepositoryProvider)
          .value!
          .getContentTypeString(contentType));
}
