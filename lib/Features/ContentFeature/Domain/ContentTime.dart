import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'ContentTime.mapper.dart';

@MappableClass()
class Time with TimeMappable {
  final int hour;
  final int minute;

  const Time({required this.hour, required this.minute});

  Time.fromDateTime(DateTime time)
      : hour = time.hour,
        minute = time.minute;

  Time.now() : this.fromDateTime(DateTime.now());

  static const int hoursPerDay = 24;

  static const int hoursPerPeriod = 12;

  static const int minutesPerHour = 60;

  Time replacing({int? hour, int? minute}) {
    assert(hour == null || (hour >= 0 && hour < hoursPerDay));
    assert(minute == null || (minute >= 0 && minute < minutesPerHour));
    return Time(hour: hour ?? this.hour, minute: minute ?? this.minute);
  }

  String format(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(
      toTimeOfDay(),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );
  }

  TimeOfDay toTimeOfDay() => TimeOfDay(hour: hour, minute: minute);

  DayPeriod get period => hour < hoursPerPeriod ? DayPeriod.am : DayPeriod.pm;

  int get hourOfPeriod => hour == 0 || hour == 12 ? 12 : hour - periodOffset;

  int get periodOffset => period == DayPeriod.am ? 0 : hoursPerPeriod;

  @override
  bool operator ==(Object other) {
    return other is TimeOfDay && other.hour == hour && other.minute == minute;
  }

  @override
  String toString() {
    String addLeadingZeroIfNeeded(int value) {
      if (value < 10) {
        return '0$value';
      }
      return value.toString();
    }

    final String hourLabel = addLeadingZeroIfNeeded(hour);
    final String minuteLabel = addLeadingZeroIfNeeded(minute);

    return '$hourLabel:$minuteLabel';
  }

  factory Time.empty() => const Time(hour: 0, minute: 0);

  factory Time.fromString(String time) {
    var s = time.split(":");
    return Time(
        hour: int.parse(s.elementAt(0)), minute: int.parse(s.elementAt(1)));
  }

  factory Time.fromFormatedString(String time) {
    final period = time.split(" ")[1].toLowerCase();
    final isAfternoon = period == "م" || period == "pm";
    final date = DateFormat.Hm().parse(time);
    return Time(
        hour: isAfternoon ? date.hour + 12 : date.hour, minute: date.minute);
  }

  factory Time.fromTimeOfDay(TimeOfDay time) =>
      Time(hour: time.hour, minute: time.minute);

  static bool isStartBeforeEnd(Time start, Time end) {
    return start.comparableDate.compareTo(end.comparableDate) == -1;
  }

  DateTime get comparableDate => DateTime(1, 1, 1, hour, minute);
}

@MappableClass()
class ContentDayTime with ContentDayTimeMappable {
  final Time open;
  final Time close;

  const ContentDayTime({required this.open, required this.close});

  factory ContentDayTime.empty() =>
      ContentDayTime(open: Time.empty(), close: Time.empty());

  bool doesIntersectWith(ContentDayTime other) {
    if (close.comparableDate.isBefore(other.open.comparableDate) ||
        other.close.comparableDate.isBefore(open.comparableDate)) {
      return false;
    }
    return true;
  }

  String format(BuildContext context) =>
      "${open.format(context)} - ${close.format(context)}";

  @override
  String toString() {
    return "${open.toString()} - ${close.toString()}";
  }
}

@MappableClass()
class ContentTime with ContentTimeMappable {
  final ContentDayTime? saturday;
  final ContentDayTime? sunday;
  final ContentDayTime? monday;
  final ContentDayTime? tuesday;
  final ContentDayTime? wednesday;
  final ContentDayTime? thursday;
  final ContentDayTime? friday;

  const ContentTime(
      {this.saturday,
      this.sunday,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday});

  factory ContentTime.empty() => const ContentTime(
      saturday: null,
      sunday: null,
      monday: null,
      tuesday: null,
      wednesday: null,
      thursday: null,
      friday: null);

  factory ContentTime.fromDay(Day day, ContentDayTime contentDayTime) =>
      switch (day) {
        Day.saturday => ContentTime(saturday: contentDayTime),
        Day.sunday => ContentTime(sunday: contentDayTime),
        Day.monday => ContentTime(monday: contentDayTime),
        Day.tuesday => ContentTime(tuesday: contentDayTime),
        Day.wednesday => ContentTime(wednesday: contentDayTime),
        Day.thursday => ContentTime(thursday: contentDayTime),
        Day.friday => ContentTime(friday: contentDayTime),
      };

  ContentTime addTime(ContentDayTime contentDayTime, Day day) => switch (day) {
        Day.saturday => copyWith(saturday: contentDayTime),
        Day.sunday => copyWith(sunday: contentDayTime),
        Day.monday => copyWith(monday: contentDayTime),
        Day.tuesday => copyWith(tuesday: contentDayTime),
        Day.wednesday => copyWith(wednesday: contentDayTime),
        Day.thursday => copyWith(thursday: contentDayTime),
        Day.friday => copyWith(friday: contentDayTime),
      };

  ContentTime deleteTime(Day day) => switch (day) {
        Day.saturday => copyWith(saturday: null),
        Day.sunday => copyWith(sunday: null),
        Day.monday => copyWith(monday: null),
        Day.tuesday => copyWith(tuesday: null),
        Day.wednesday => copyWith(wednesday: null),
        Day.thursday => copyWith(thursday: null),
        Day.friday => copyWith(friday: null),
      };
}

@MappableEnum()
enum Day { saturday, sunday, monday, tuesday, wednesday, thursday, friday }
