import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/ContentFeature/Domain/Content.dart';
import 'package:baha_platform/Features/ContentFeature/Presentation/Notifiers/ContentManagerNotifier.dart';
import 'package:baha_platform/Features/ContentFeature/Presentation/Notifiers/ContentProvider.dart';
import 'package:baha_platform/Features/ContentFeature/Presentation/_Widgets/CommentWidget.dart';
import 'package:baha_platform/Features/ContentFeature/Presentation/_Widgets/ContentEmergencyNumberWidget.dart';
import 'package:baha_platform/Features/SplashFeature/ErrorView.dart';
import 'package:baha_platform/Features/SplashFeature/LoadingView.dart';
import 'package:baha_platform/Features/_SharedData/ImagePickerNotifier.dart';
import 'package:baha_platform/Features/_SharedData/LocalizedString.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/AssetsManager.dart';
import 'package:baha_platform/utils/Resouces/ValuesManager.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Router/MyRoutes.gr.dart';
import '../../../utils/Resouces/theme.dart';
import '../../AuthenticationFeature/Data/AuthController.dart';
import '../../AuthenticationFeature/Domain/UserRole.dart';
import '../../_SharedData/TextIcon.dart';
import '../Domain/ContentTime.dart';
import '_Widgets/ContentServicesWidget.dart';
import '_Widgets/ContentTimeWidget.dart';

@RoutePage()
class ContentView extends ConsumerStatefulWidget {
  final String contentId;

  const ContentView({super.key, required this.contentId});

  @override
  ConsumerState createState() => _ContentViewState();
}

class _ContentViewState extends ConsumerState<ContentView> {
  final TextEditingController commentController = TextEditingController();
  final GlobalKey storyCaptureLocationKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(getContentByIdProvider(widget.contentId)).when(
            data: (data) => CustomScrollView(
              slivers: [
                buildAppBar(data.title, data.imagesURLs),
                SliverPadding(
                  padding: const EdgeInsets.all(PaddingValuesManager.p20),
                  sliver: SliverList.list(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: PaddingValuesManager.p10),
                      child: Align(
                        child: TextIconWidget(
                            icon: Icons.description,
                            text:
                                Text(ref.getLocalizedString(data.description))),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: PaddingValuesManager.p10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextIconWidget(
                            icon: Icons.location_on,
                            text: Text(
                              ref.getLocalizedString(data.area),
                            ),
                          ),
                          IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () => Uri.parse(data.areaURL).launch(),
                              icon: const Icon(
                                  IconsAssetsManager.addressURLOnMap,
                                  color: ColorManager.primary))
                        ],
                      ),
                    ),
                    if (data.contentDate != null)
                      buildContentDate(data.contentDate!),
                    if (data.distanceFromCenter != null)
                      buildDistance(data.distanceFromCenter!),
                    if (data.services.isNotEmpty)
                      buildContentLists(data.services, false),
                    if (data.facilities.isNotEmpty)
                      buildContentLists(data.facilities, true),
                    if (data.contentTime != null)
                      buildContentOpenCloseTimesListWidget(data.contentTime!),
                    buildContentEmergencyNumbersList(),
                    buildAddStory(context, data),
                    if (ref.watch(authControllerProvider).requireValue is Admin)
                      buildAdminButtons(context, data),
                    buildAddComment(context, data),
                    buildComments(data)
                  ]),
                ),
              ],
            ),
            error: (error, stackTrace) => ErrorView(error: error),
            loading: () => const LoadingView(),
          ),
    );
  }

  Widget buildAppBar(LocalizedString title, List<String> imagesURLs) =>
      SliverAppBar(
        expandedHeight: 300.0,
        pinned: true,
        flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return FlexibleSpaceBar(
              centerTitle: true,
              title: Text(ref.getLocalizedString(title)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 300.0,
                      viewportFraction: 1.0,
                      autoPlay: true,
                      enlargeCenterPage: false,
                    ),
                    items: imagesURLs.map((url) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Image.network(
                            url,
                            fit: BoxFit.contain,
                            width: double.infinity,
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100.0,
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
            );
          },
        ),
      );

  Widget buildContentDate(DateTime contentDate) => Padding(
        padding: const EdgeInsets.symmetric(vertical: PaddingValuesManager.p10),
        child: TextIconWidget(
            icon: Icons.date_range, text: Text(contentDate.toRegularDate())),
      );

  Widget buildContentOpenCloseTimesListWidget(ContentTime times) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        TextIconWidget(
            icon: IconsAssetsManager.openCloseTimes,
            text: Text(context.strings.openAndCloseTimes,
                style: Theme.of(context).textTheme.titleMedium)),
        Padding(
            padding:
                const EdgeInsets.symmetric(vertical: PaddingValuesManager.p10),
            child: ContentTimeWidget(contentTime: times))
      ],
    );
  }

  Widget buildDistance(double distanceFromCenter) => Padding(
        padding: const EdgeInsets.symmetric(vertical: PaddingValuesManager.p10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Text(
              context.strings.distanceFromCenter,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: PaddingValuesManager.p10),
              child: Text(
                  "${distanceFromCenter.toStringAsFixed(2)} ${context.strings.km}"),
            )
          ],
        ),
      );

  Widget buildContentEmergencyNumbersList() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          TextIconWidget(
            icon: IconsAssetsManager.emergencyNumbers,
            text: Text(context.strings.emergencyNumbers,
                style: Theme.of(context).textTheme.titleMedium),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: PaddingValuesManager.p10),
            child: Wrap(
              direction: Axis.horizontal,
              runSpacing: PaddingValuesManager.p5,
              spacing: PaddingValuesManager.p5,
              children: [
                ContentEmergencyNumberWidget(
                    text: context.strings.civilDefence, number: "998"),
                ContentEmergencyNumberWidget(
                    text: context.strings.ambulance, number: "997"),
                ContentEmergencyNumberWidget(
                    text: context.strings.police, number: "999"),
                ContentEmergencyNumberWidget(
                    text: context.strings.trafficPolice, number: "993"),
                ContentEmergencyNumberWidget(
                    text: context.strings.securityPatrols, number: "993"),
                ContentEmergencyNumberWidget(
                    text: context.strings.electricity, number: "993"),
              ],
            ),
          ),
        ],
      );

  Widget buildContentLists(List<LocalizedString> list, bool isFacilities) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Text(
              isFacilities
                  ? context.strings.facilities
                  : context.strings.services,
              style: Theme.of(context).textTheme.titleMedium),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: PaddingValuesManager.p10),
            child: Wrap(
              direction: Axis.horizontal,
              runSpacing: PaddingValuesManager.p5,
              spacing: PaddingValuesManager.p5,
              children: [
                for (int i = 0; i < list.length; i++)
                  ContentServicesWidget(string: list.elementAt(i))
              ],
            ),
          ),
        ],
      );

  Widget buildAddStory(BuildContext context, Content data) => Padding(
        padding: const EdgeInsets.symmetric(vertical: PaddingValuesManager.p10),
        child: ElevatedButton(
            key: storyCaptureLocationKey,
            onPressed: () async {
              var isCamera = await buildStoryCapturePopupButtons();
              if (isCamera == null) return;
              if (isCamera && context.mounted) {
                context.router.push(StoryCaptureRoute(contentMetaData: (
                  contentId: widget.contentId,
                  contentType: data.type
                )));
                return;
              }
              var storyMedia = await ref
                  .read(imagePickerNotifierProvider.notifier)
                  .pickImage();

              if (storyMedia == null) return;
              if (context.mounted) {
                context.router.push(StoryCaptureRoute(
                    withPreSelection: storyMedia,
                    contentMetaData: (
                      contentId: widget.contentId,
                      contentType: data.type
                    )));
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: PaddingValuesManager.p10),
                  child: Text(context.strings.addStory),
                ),
                const Icon(
                  IconsAssetsManager.cameraIcon,
                  color: ColorManager.secondaryContainer,
                )
              ],
            )),
      );

  Widget buildAddComment(BuildContext context, Content data) => Column(
        children: [
          const Divider(),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: context.strings.addAComment,
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: ColorManager.secondary),
                onPressed: () async {
                  await ref
                      .read(contentManagerNotifierProvider(
                              contentDTO: data.toDTO())
                          .notifier)
                      .addComment(text: commentController.value.text);
                },
              ),
            ],
          ),
          const Divider()
        ],
      );

  Future<bool?> buildStoryCapturePopupButtons() async {
    final Offset position = (storyCaptureLocationKey.currentContext!
            .findRenderObject() as RenderBox)
        .localToGlobal(Offset.zero);
    return showMenu<bool?>(
        context: context,
        position: RelativeRect.fromLTRB(
          position.dx,
          position.dy,
          position.dx,
          position.dy,
        ),
        items: [
          PopupMenuItem(value: true, child: Text(context.strings.camera)),
          PopupMenuItem(value: false, child: Text(context.strings.studio))
        ]);
  }

  Widget buildAdminButtons(BuildContext context, Content content) => Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => context.router
                  .push(ContentManageRoute(content: content.toDTO())),
              style: ThemeManager.getElevatedButtonThemeEdit().style,
              child: Text(context.strings.editContent),
            ),
          ),
          const SizedBox(width: AppSizeManager.s10),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                var result = await ref
                    .read(contentManagerNotifierProvider(
                            contentDTO: content.toDTO())
                        .notifier)
                    .deleteContent();
                if (result && context.mounted) {
                  await context.router.maybePop();
                }
              },
              style: ThemeManager.getElevatedButtonThemeRisk().style,
              child: Text(context.strings.deleteContent),
            ),
          ),
        ],
      );

  Widget buildComments(Content content) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: content.comments.length,
        itemBuilder: (context, index) {
          return CommentWidget(
              comment: content.comments.elementAt(index),
              removeFunc: () => ref
                  .read(contentManagerNotifierProvider(
                          contentDTO: content.toDTO())
                      .notifier)
                  .deleteComment(content.comments.elementAt(index)));
        },
      );
}
