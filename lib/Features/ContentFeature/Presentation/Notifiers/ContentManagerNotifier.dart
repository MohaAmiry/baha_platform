import 'package:baha_platform/Features/ContentFeature/Domain/Comment.dart';
import 'package:baha_platform/Features/ContentFeature/Domain/Content.dart';
import 'package:baha_platform/Features/_SharedData/AbstractDataRepository.dart';
import 'package:baha_platform/Features/_SharedData/LocalizedString.dart';
import 'package:baha_platform/Localization/LocalizationProvider.dart';
import 'package:baha_platform/Localization/LocalizationRepository.dart';
import 'package:baha_platform/utils/Enums.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/SharedOperations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../ExceptionHandler/MessageEmitter.dart';
import '../../../AuthenticationFeature/Data/AuthController.dart';
import '../../../_SharedData/ImagePickerNotifier.dart';
import '../../Domain/ContentTime.dart';

part 'ContentManagerNotifier.g.dart';

@riverpod
class ContentManagerNotifier extends _$ContentManagerNotifier
    with SharedUserOperations {
  @override
  ContentDTO build({ContentDTO? contentDTO}) {
    return contentDTO ?? ContentDTO.empty();
  }

  void setTitle(String title) => state = state.copyWith(
      title: LocalizedString(en: title.trim(), ar: title.trim()));

  void setAreaMapURL(String url) => state = state.copyWith(areaURL: url);

  void setDescription(String description) => state = state.copyWith(
      description:
          LocalizedString(en: description.trim(), ar: description.trim()));

  void setDistance(double? distance) =>
      state = state.copyWith(distanceFromCenter: distance);

  void setDate(DateTime? date) => state = state.copyWith(contentDate: date);

  void setType(ContentType type) => state = state.copyWith(type: type);

  void setArea(String area) => state =
      state.copyWith(area: LocalizedString(en: area.trim(), ar: area.trim()));

  void addFacility(String facility) => facility.isNotEmpty
      ? state = state.copyWith.facilities
          .add(LocalizedString(en: facility.trim(), ar: facility.trim()))
      : null;

  void addService(String service) => service.isNotEmpty
      ? state = state.copyWith.services
          .add(LocalizedString(en: service.trim(), ar: service.trim()))
      : null;

  void deleteFacility(int index) =>
      state = state.copyWith.facilities.removeAt(index);

  void deleteService(int index) {
    state = state.copyWith.services.removeAt(index);
  }

  void addDayTime(String open, String close, Day day) {
    if (open.isEmpty || close.isEmpty) return;

    final timeToSet = ContentDayTime(
        open: Time.fromFormatedString(open),
        close: Time.fromFormatedString(close));
    bool isValidTime = Time.isStartBeforeEnd(timeToSet.open, timeToSet.close);
    if (!isValidTime) {
      ref.read(messageEmitterProvider.notifier).setFailed(
          message: Exception(ref
              .read(localizationProvider)
              .exceptionEndTimeCantBeBeforeStartTime),
          stackTrace: StackTrace.current);
      return;
    }
    state = state.copyWith(
        contentTime: state.contentTime == null
            ? ContentTime.fromDay(day, timeToSet)
            : state.contentTime!.addTime(timeToSet, day));
  }

  void deleteDayTime(Day day) {
    state = state.copyWith(
        contentTime: state.contentTime == null
            ? ContentTime.empty()
            : state.contentTime!.deleteTime(day));
  }

  void deleteAllDayTimes() {
    state = state.copyWith(contentTime: null);
  }

  Future<bool> setImages() async {
    var result = await AsyncValue.guard(
        () => ref.read(imagePickerNotifierProvider.notifier).pickImages());
    if (result.hasError) {
      ref.read(messageEmitterProvider.notifier).setFailed(
          message: Exception(result.error.toString()),
          stackTrace: StackTrace.empty);
      return false;
    }
    state = state.copyWith(imagesURLs: result.requireValue.toList());
    return true;
  }

  Future<bool> addContent() async {
    var result = await ref.operationPipeLine(
      func: () async {
        validateContent();
        return ref
            .read(repositoryClientProvider)
            .contentRepository
            .addContent(state);
      },
    );
    return result.hasValue;
  }

  Future<bool> deleteContent() async {
    var result = await ref.operationPipeLine(
      func: () => ref
          .read(repositoryClientProvider)
          .contentRepository
          .deleteContent(state.id),
    );
    if (result.hasError) return false;
    return result.hasValue;
  }

  Future<bool> updateContent(bool withUpdateImages) async {
    var result = await ref.operationPipeLine(func: () {
      validateContent();
      return ref.read(repositoryClientProvider).contentRepository.updateContent(
          updatedContentDTO: state, withUpdateImages: withUpdateImages);
    });
    return result.hasValue;
  }

  Future<bool> addComment({required String text}) async {
    if (text.trim().isEmpty) return false;
    var result = await ref.operationPipeLine(
        func: () => ref
            .read(repositoryClientProvider)
            .contentRepository
            .addComment(text.trim(), state.id,
                ref.read(authControllerProvider).requireValue!.user!.uid));
    if (result.hasError) {
      return false;
    }

    return true;
  }

  Future<void> deleteComment(Comment comment) async {
    await ref.operationPipeLine(
        func: () => ref
            .read(repositoryClientProvider)
            .contentRepository
            .commentsRepository
            .deleteComment(comment.toDTO(), state.id));
  }

  bool validateContent() {
    if (state.title.ar.isEmpty) {
      throw Exception(ref.read(localizationProvider).exceptionTitleCantBeEmpty);
    }
    if (state.description.ar.isEmpty) {
      throw Exception(
          ref.read(localizationProvider).exceptionDescriptionCantBeEmpty);
    }
    if (state.area.ar.isEmpty) {
      throw Exception(ref.read(localizationProvider).exceptionAreaCantBeEmpty);
    }
    if (state.imagesURLs.isEmpty) {
      throw Exception(ref.read(localizationProvider).exceptionAddAtLeast1Image);
    }
    if (!isValidURL(state.areaURL)) {
      throw Exception(
          ref.read(localizationProvider).exceptionAreaMapURLIsNotValid);
    }
    return true;
  }

  Future<void> translateContent() async {
    if (state.title.en != state.title.ar) return;

    var locProvider = ref.read(localizationRepositoryProvider).requireValue;
    var localizedTitle = locProvider.localizeString(state.title);
    var localizedDescription = locProvider.localizeString(state.description);
    var localizedArea = locProvider.localizeString(state.area);
    var localizedFacilities = locProvider.localizeStringList(state.facilities);
    var localizedServices = locProvider.localizeStringList(state.services);
    state = state.copyWith(
        title: await localizedTitle,
        description: await localizedDescription,
        area: await localizedArea,
        facilities: await localizedFacilities,
        services: await localizedServices);
  }
}
