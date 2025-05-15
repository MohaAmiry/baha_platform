import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/ContentFeature/Domain/Content.dart';
import 'package:baha_platform/Features/ContentFeature/Presentation/Notifiers/ContentManagerNotifier.dart';
import 'package:baha_platform/Features/ContentFeature/Presentation/_Widgets/ContentServicesWidget.dart';
import 'package:baha_platform/Localization/LocalizationProvider.dart';
import 'package:baha_platform/Localization/LocalizationRepository.dart';
import 'package:baha_platform/utils/Enums.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/AssetsManager.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ExceptionHandler/MessageEmitter.dart';
import '../../../utils/Resouces/ValuesManager.dart';
import '../../../utils/Resouces/theme.dart';
import '../Domain/ContentTime.dart';

@RoutePage()
class ContentManageView extends ConsumerStatefulWidget {
  final ContentDTO? content;

  const ContentManageView({super.key, this.content});

  @override
  ConsumerState createState() => _ContentManageViewState();
}

class _ContentManageViewState extends ConsumerState<ContentManageView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeOpenController = TextEditingController();
  final TextEditingController timeCloseController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController servicesTextController = TextEditingController();
  final TextEditingController facilitiesTextController =
      TextEditingController();
  final TextEditingController emergencyTextController = TextEditingController();

  bool updatedImages = false;
  bool addOpenCloseTimes = false;
  Day day = Day.sunday;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    areaController.dispose();
    dateController.dispose();
    timeCloseController.dispose();
    timeOpenController.dispose();
    distanceController.dispose();
    servicesTextController.dispose();
    facilitiesTextController.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future(
      () {
        if (widget.content != null) {
          var provider =
              contentManagerNotifierProvider(contentDTO: widget.content);
          ref.read(provider);
          titleController.text = ref.read(provider).title.ar;
          descriptionController.text = ref.read(provider).description.ar;
          areaController.text = ref.read(provider).area.ar;
          if (ref.read(provider).contentDate != null) {
            dateController.text =
                ref.read(provider).contentDate!.toRegularDate();
          }
          if (ref.read(provider).distanceFromCenter != null) {
            distanceController.text =
                ref.read(provider).distanceFromCenter!.toStringAsFixed(2);
          }
          if (ref.read(provider).contentTime != null) {
            setState(() {
              addOpenCloseTimes = true;
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = contentManagerNotifierProvider(contentDTO: widget.content);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          buildAppBar(provider),
          SliverPadding(
            padding: const EdgeInsets.all(PaddingValuesManager.p10),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(PaddingValuesManager.p10),
                    child: ElevatedButton(
                      onPressed: () async {
                        var result =
                            await ref.read(provider.notifier).setImages();
                        if (result) {
                          setState(() {
                            updatedImages = true;
                          });
                        }
                      },
                      child: Text(context.strings.addImages),
                    ),
                  ),
                  buildContentTypeSelector(provider),
                  TextFormField(
                      controller: titleController,
                      onChanged: (value) =>
                          ref.read(provider.notifier).setTitle(value),
                      decoration: InputDecoration(
                          helperText: context.strings.emptyString,
                          labelText: context.strings.contentTitle,
                          hintText: context.strings.contentTitle)),
                  TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      controller: descriptionController,
                      onChanged: (value) =>
                          ref.read(provider.notifier).setDescription(value),
                      decoration: InputDecoration(
                          helperText: context.strings.emptyString,
                          labelText: context.strings.contentDescription,
                          hintText: context.strings.contentDescription)),
                  TextFormField(
                      controller: areaController,
                      onChanged: (value) =>
                          ref.read(provider.notifier).setArea(value),
                      decoration: InputDecoration(
                          helperText: context.strings.emptyString,
                          labelText: context.strings.contentArea,
                          hintText: context.strings.contentArea)),
                  TextFormField(
                      onChanged: (value) =>
                          ref.read(provider.notifier).setAreaMapURL(value),
                      decoration: InputDecoration(
                          helperText: context.strings.emptyString,
                          labelText: context.strings.contentAreaMapURL,
                          hintText: context.strings.contentAreaMapURL)),
                  TextFormField(
                      controller: distanceController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) => ref
                          .read(provider.notifier)
                          .setDistance(double.tryParse(value)),
                      decoration: InputDecoration(
                          helperText: context.strings.emptyString,
                          labelText: context.strings.distanceFromCenterInKM,
                          hintText: context.strings.distanceFromCenterInKM)),
                  buildDateWidget(provider),
                  buildContentLists(true, provider),
                  const Divider(),
                  buildContentLists(false, provider),
                  const Divider(),
                  buildContentOpenCloseTimesWidget(provider),
                  const Divider(),
                  const SizedBox(height: PaddingValuesManager.p20),
                  ElevatedButton(
                      onPressed: () async {
                        if (widget.content == null) {
                          var didAdd =
                              await ref.read(provider.notifier).addContent();
                          if (didAdd && context.mounted) {
                            context.router.maybePop();
                          }
                          return;
                        }
                        var didEdit = await ref
                            .read(provider.notifier)
                            .updateContent(updatedImages);
                        if (didEdit && context.mounted) {
                          context.router.maybePop();
                        }
                      },
                      child: Text(context.strings.confirm)),
                  SizedBox(height: MediaQuery.sizeOf(context).height * .1)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppBar(ContentManagerNotifierProvider provider) => SliverAppBar(
        expandedHeight: 300.0,
        pinned: true,
        flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return FlexibleSpaceBar(
              centerTitle: true,
              title: Text(ref.watch(provider).title.ar),
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
                    items: ref.watch(provider).imagesURLs.map((url) {
                      return widget.content == null || updatedImages
                          ? Builder(
                              builder: (BuildContext context) {
                                return Image.file(
                                  File(url),
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                );
                              },
                            )
                          : Builder(
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

  Widget buildContentLists(
          bool isService, ContentManagerNotifierProvider provider) =>
      Column(
        children: [
          buildAddToList(isService, provider),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: isService
                  ? ref.watch(provider).services.length
                  : ref.watch(provider).facilities.length,
              itemBuilder: (context, index) => ContentServicesWidget(
                  isInEditFunc: () => isService
                      ? ref.read(provider.notifier).deleteService(index)
                      : ref.read(provider.notifier).deleteFacility(index),
                  string: isService
                      ? ref.watch(provider).services.elementAt(index)
                      : ref.watch(provider).facilities.elementAt(index))),
        ],
      );

  Widget buildContentOpenCloseTimesSelectionWidget(
          ContentManagerNotifierProvider provider) =>
      Column(
        children: [
          buildContentOpenCloseSingleTimeSelectorWidget(),
          buildContentOpenCloseTextFieldsWidget(provider),
          buildContentOpenCloseSelectedTimesListWidget(provider)
        ],
      );

  Widget buildContentOpenCloseTimesWidget(
          ContentManagerNotifierProvider provider) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
              value: addOpenCloseTimes,
              onChanged: (value) {
                setState(() {
                  addOpenCloseTimes = value!;
                });
                if (value == false) {
                  ref.read(provider.notifier).deleteAllDayTimes();
                }
              },
              title: Text(context.strings.addOpenCloseTimes)),
          if (addOpenCloseTimes)
            buildContentOpenCloseTimesSelectionWidget(provider)
        ],
      );

  Widget buildContentOpenCloseSelectedTimesListWidget(
      ContentManagerNotifierProvider provider) {
    final times = ref.watch(provider).contentTime;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PaddingValuesManager.p10),
      child: Column(
        children: [
          buildContentOpenCloseSingleDayWidget(
              times?.sunday, Day.sunday, provider),
          buildContentOpenCloseSingleDayWidget(
              times?.monday, Day.monday, provider),
          buildContentOpenCloseSingleDayWidget(
              times?.tuesday, Day.tuesday, provider),
          buildContentOpenCloseSingleDayWidget(
              times?.wednesday, Day.wednesday, provider),
          buildContentOpenCloseSingleDayWidget(
              times?.thursday, Day.thursday, provider),
          buildContentOpenCloseSingleDayWidget(
              times?.friday, Day.friday, provider),
          buildContentOpenCloseSingleDayWidget(
              times?.saturday, Day.saturday, provider),
        ],
      ),
    );
  }

  Widget buildContentOpenCloseSingleDayWidget(ContentDayTime? contentDayTime,
          Day day, ContentManagerNotifierProvider provider) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              "${ref.read(localizationRepositoryProvider).requireValue.getLocalizedDay(day)}: ${contentDayTime == null ? ref.read(localizationProvider).closed : contentDayTime.format(context)}"),
          IconButton(
              onPressed: () => ref.read(provider.notifier).deleteDayTime(day),
              icon: const Icon(IconsAssetsManager.delete))
        ],
      );

  Widget buildContentOpenCloseSingleTimeSelectorWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.strings.selectDay,
              style: Theme.of(context).textTheme.titleMedium),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: PaddingValuesManager.p20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizeManager.s10)),
            child: DropdownButton(
              hint: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(context.strings.selectDay)),
              isExpanded: true,
              alignment: Alignment.bottomCenter,
              elevation: 0,
              borderRadius: BorderRadius.circular(AppSizeManager.s10),
              value: day,
              icon: const Icon(Icons.keyboard_arrow_down),
              isDense: true,
              menuMaxHeight: MediaQuery.sizeOf(context).height * 0.4,
              padding: const EdgeInsets.symmetric(
                  horizontal: PaddingValuesManager.p10,
                  vertical: PaddingValuesManager.p10),
              items: [
                DropdownMenuItem(
                    value: Day.sunday, child: Text(context.strings.sunday)),
                DropdownMenuItem(
                    value: Day.monday, child: Text(context.strings.monday)),
                DropdownMenuItem(
                    value: Day.tuesday, child: Text(context.strings.tuesday)),
                DropdownMenuItem(
                    value: Day.wednesday,
                    child: Text(context.strings.wednesday)),
                DropdownMenuItem(
                    value: Day.thursday, child: Text(context.strings.thursday)),
                DropdownMenuItem(
                    value: Day.friday, child: Text(context.strings.friday)),
                DropdownMenuItem(
                    value: Day.saturday, child: Text(context.strings.saturday)),
              ],
              onChanged: (value) => setState(() => day = value!),
            ),
          ),
        ],
      );

  Widget buildContentOpenCloseTextFieldsWidget(
          ContentManagerNotifierProvider provider) =>
      Column(
        children: [
          InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                pickedTime == null
                    ? timeOpenController.text = ""
                    : timeOpenController.text =
                        Time.fromTimeOfDay(pickedTime).format(context);
              },
              child: TextFormField(
                controller: timeOpenController,
                enabled: false,
                decoration: InputDecoration(
                  hintText: context.strings.openTime,
                  labelText: context.strings.openTime,
                  helperText: "",
                ),
              )),
          InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              onTap: () async {
                if (timeOpenController.value.text.isEmpty) {
                  ref.read(messageEmitterProvider.notifier).setFailed(
                      message: Exception(
                          context.strings.exceptionSelectOpenTimeFirst),
                      stackTrace: StackTrace.empty);
                  return;
                }
                var toTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (toTime == null) return;

                var parsedFromTime =
                    Time.fromFormatedString(timeOpenController.text);
                var parsedToTime = Time.fromTimeOfDay(toTime);
                if (!Time.isStartBeforeEnd(parsedFromTime, parsedToTime) &&
                    context.mounted) {
                  ref.read(messageEmitterProvider.notifier).setFailed(
                      message: Exception(context
                          .strings.exceptionCloseTimeCantBeBeforeStartTime),
                      stackTrace: StackTrace.empty);
                  return;
                }
                timeCloseController.text = parsedToTime.format(context);
              },
              child: TextFormField(
                controller: timeCloseController,
                enabled: false,
                decoration: InputDecoration(
                  hintText: context.strings.closeTime,
                  labelText: context.strings.closeTime,
                  helperText: "",
                ),
              )),
          ElevatedButton(
              onPressed: () => ref.read(provider.notifier).addDayTime(
                  timeOpenController.value.text,
                  timeCloseController.value.text,
                  day),
              child: Text(context.strings.setTime)),
        ],
      );

  Widget buildAddToList(
          bool isService, ContentManagerNotifierProvider provider) =>
      Row(
        children: [
          Expanded(
            child: TextField(
              controller:
                  isService ? servicesTextController : facilitiesTextController,
              decoration: InputDecoration(
                hintText: isService
                    ? context.strings.addService
                    : context.strings.addFacility,
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: ColorManager.secondary),
            onPressed: () {
              if (isService) {
                if (servicesTextController.value.text.isNotEmpty) {
                  ref
                      .read(provider.notifier)
                      .addService(servicesTextController.value.text);
                  return;
                }
              } else {
                if (facilitiesTextController.value.text.isNotEmpty) {
                  ref
                      .read(provider.notifier)
                      .addFacility(facilitiesTextController.value.text);
                  return;
                }
              }
            },
          ),
        ],
      );

  Widget buildContentTypeSelector(ContentManagerNotifierProvider provider) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.strings.contentType,
              style: Theme.of(context).textTheme.titleMedium),
          DropdownButton(
            hint: Align(
                alignment: Alignment.centerLeft,
                child: Text(context.strings.contentType)),
            isExpanded: true,
            alignment: Alignment.bottomCenter,
            elevation: 0,
            borderRadius: BorderRadius.circular(AppSizeManager.s10),
            value: ref.watch(provider).type,
            icon: const Icon(Icons.keyboard_arrow_down),
            isDense: true,
            menuMaxHeight: MediaQuery.sizeOf(context).height * 0.4,
            padding: const EdgeInsets.symmetric(
                horizontal: PaddingValuesManager.p10,
                vertical: PaddingValuesManager.p10),
            items: [
              DropdownMenuItem(
                  value: ContentType.archaeologicalVillages,
                  child: Text(
                    context.strings.archaeologicalVillages,
                  )),
              DropdownMenuItem(
                  value: ContentType.cafes,
                  child: Text(
                    context.strings.cafes,
                  )),
              DropdownMenuItem(
                  value: ContentType.resorts,
                  child: Text(
                    context.strings.resorts,
                  )),
              DropdownMenuItem(
                  value: ContentType.farms,
                  child: Text(
                    context.strings.farms,
                  )),
              DropdownMenuItem(
                  value: ContentType.festivals,
                  child: Text(
                    context.strings.festivals,
                  )),
              DropdownMenuItem(
                  value: ContentType.forests,
                  child: Text(
                    context.strings.forests,
                  )),
              DropdownMenuItem(
                  value: ContentType.hotels,
                  child: Text(
                    context.strings.hotels,
                  )),
              DropdownMenuItem(
                  value: ContentType.parks,
                  child: Text(
                    context.strings.parks,
                  )),
            ],
            onChanged: (value) => ref.read(provider.notifier).setType(value!),
          ),
          const Divider()
        ],
      );

  Widget buildDateWidget(ContentManagerNotifierProvider provider) => InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(AppSizeManager.s10)),
      onTap: () async {
        DateTime? dateTime = await showDatePicker(
          context: context,
          keyboardType: TextInputType.datetime,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(
            const Duration(days: 900),
          ),
        );
        ref.read(provider.notifier).setDate(dateTime);
        dateController.text = dateTime == null ? "" : dateTime.toRegularDate();
      },
      child: TextFormField(
        controller: dateController,
        enabled: false,
        decoration: InputDecoration(
          hintText: context.strings.contentDate,
          labelText: context.strings.contentDate,
          helperText: null,
        ),
      ));
}
