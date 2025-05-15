import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserRole.dart';
import 'package:baha_platform/Features/_SharedData/LocalizedString.dart';
import 'package:baha_platform/Localization/LocalizationProvider.dart';
import 'package:baha_platform/Localization/LocalizationRepository.dart';
import 'package:baha_platform/utils/Enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ExceptionHandler/MessageEmitter.dart';

extension StringExtension on String {
  String ifIsEmpty(String placeholder) => this.isEmpty ? placeholder : this;
}

extension LocalizedBuildContext on BuildContext {
  AppLocalizations get strings => AppLocalizations.of(this)!;
}

extension LanguageLocalizationName on Locale {
  String translateLocaleName() {
    switch (toLanguageTag()) {
      case ("en-US"):
        return "English";
      case ("ar-AE"):
        return "عربي";
      default:
        {
          return "N/A";
        }
    }
  }
}

extension StringLocalization on WidgetRef {
  String getLocalizedString(LocalizedString string) =>
      watch(localizationControllerProvider).requireValue.languageCode == "ar"
          ? string.ar
          : string.en;

  String getLocalizedContentType(ContentType contentType) =>
      watch(localizationRepositoryProvider)
          .requireValue
          .getContentTypeString(contentType);

  String getLocalizedShopType(ShopTypeEnum shopType) =>
      watch(localizationRepositoryProvider)
          .requireValue
          .getLocalizedShopType(shopType);

  String getLocalizedProductsType(ShopTypeEnum shopType) =>
      watch(localizationRepositoryProvider)
          .requireValue
          .getLocalizedProductsType(shopType);

  String getLocalizedTimeType(TimeType timeType) =>
      read(localizationRepositoryProvider)
          .requireValue
          .getLocalizedTimeType(timeType);

  String getLocalizedOrderState(bool? state) =>
      read(localizationRepositoryProvider)
          .requireValue
          .getLocalizedOrderState(state);

  String getLocalizedStoryTimeType(StoryTimeType timeType) =>
      read(localizationRepositoryProvider)
          .requireValue
          .getLocalizedStoryTimeType(timeType);
}

extension DateFormatter on DateTime {
  String toRegularDate() => DateFormat("yyyy/MM/dd").format(this);

  String toMonthDayDate() => DateFormat("MM/dd").format(this);

  String toRegularDateWithTime(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    return DateFormat('yyyy/MM/dd hh:mm:ss a').format(this);
  }

  ({int numAgo, TimeType timeType}) toTimeAgo() {
    final now = DateTime.now();
    final duration = now.difference(this);

    if (duration.inDays < 30) {
      return (numAgo: duration.inDays, timeType: TimeType.days);
    } else if (duration.inDays < 365) {
      final months = (duration.inDays / 30).floor();
      return (numAgo: months, timeType: TimeType.months);
    } else {
      final years = (duration.inDays / 365).floor();
      return (numAgo: years, timeType: TimeType.years);
    }
  }

  ({int numAgo, StoryTimeType storyTimeType}) toTimeAgoStory() {
    final Duration difference = DateTime.now().difference(this);

    if (difference.inSeconds < 60) {
      return (
        numAgo: difference.inSeconds,
        storyTimeType: StoryTimeType.second
      );
    } else if (difference.inMinutes < 60) {
      return (
        numAgo: difference.inMinutes,
        storyTimeType: StoryTimeType.minute
      );
    }
    return (numAgo: difference.inHours, storyTimeType: StoryTimeType.hour);
  }

  String toRegularDateYM() => DateFormat("yyyy/MM").format(this);

  String toTime() => DateFormat(DateFormat.HOUR_MINUTE_TZ).format(this);
}

extension TimeOfDayExtension on TimeOfDay {
  bool isStartBeforeEnd(TimeOfDay end) {
    return comparableDate.compareTo(end.comparableDate) == -1;
  }

  DateTime get comparableDate => DateTime(1, 1, 1, hour, minute);

  static TimeOfDay fromString(String time) {
    return TimeOfDay(hour: 1, minute: 2);
  }
}

extension Pipeline<T, R> on Ref<T> {
  Future<AsyncValue<R>> operationPipeLine<R>(
      {required Future<R> Function() func,
      String? pendingMessage,
      String? successMessage}) async {
    read(messageEmitterProvider.notifier).setPending(message: pendingMessage);
    var result = await AsyncValue.guard(func);
    if (result.hasError) {
      read(messageEmitterProvider.notifier).setFailed(
          message: Exception(result.error.toString()),
          stackTrace: StackTrace.current);
    } else if (result.hasValue) {
      read(messageEmitterProvider.notifier)
          .setSuccessfulMessage(message: successMessage);
    }
    return result;
  }
}

extension LaunchURI on Uri {
  Future<AsyncValue<bool>> launch() async {
    if (await canLaunchUrl(this)) {
      await launchUrl(this, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $this';
    }
    return const AsyncData(true);
  }

  Future<void> launchPhoneCall() async {
    if (await canLaunchUrl(this)) {
      await launchUrl(this);
    } else {
      throw 'Could not launch $this';
    }
  }
}
