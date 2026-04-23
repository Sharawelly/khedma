import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/core/utils/enums.dart';
import '/core/utils/string_extension.dart';
import '../../config/locale/app_localizations.dart';

class MyDate {
  static String getFilterDay(AvailableTimes date) {
    final today = DateTime.now();
    if (date == AvailableTimes.today) {
      String formated = DateFormat('yyyy-MM-dd').format(today);
      return formated;
    } else {
      final tomorrow = DateTime(today.year, today.month, today.day + 1);
      String formated = DateFormat('yyyy-MM-dd').format(tomorrow);
      return formated;
    }
  }

  static bool checkIfSame(String date, String selected) {
    DateTime date1 = DateFormat('yyyy-MM-dd').parse(date);
    DateTime date2 = DateFormat('yyyy-MM-dd').parse(selected);
    return date1.isSameDate(date2);
  }

  static String getNextMonth(String date) {
    DateTime parseDt = DateFormat('yyyy-MM-dd').parse(date);
    DateTime nextMonth = DateTime(parseDt.year, parseDt.month + 1, 1);
    String formated = DateFormat('yyyy-MM-dd').format(nextMonth);

    return formated;
  }

  static String getPreMonth(String date) {
    DateTime parseDt = DateFormat('yyyy-MM-dd').parse(date);
    DateTime nextMonth = DateTime(parseDt.year, parseDt.month - 1, 1);
    String formated = DateFormat('yyyy-MM-dd').format(nextMonth);

    return formated;
  }

  static String getMonthYear(String date, BuildContext context) {
    bool isRTL = AppLocalizations.of(context)!.isArLocale;

    DateTime parseDt = DateFormat('yyyy-MM-dd').parse(date);
    String formated = DateFormat.yMMMM(
      isRTL ? 'ar_SA' : 'en_US',
    ).format(parseDt);

    return formated;
  }

  static String getMonth(String date, BuildContext context) {
    bool isRTL = AppLocalizations.of(context)!.isArLocale;

    DateTime parseDt = DateFormat('yyyy-MM-dd').parse(date);
    String formated = DateFormat.MMMM(
      isRTL ? 'ar_SA' : 'en_US',
    ).format(parseDt);

    return formated;
  }

  static String getDay(String date, BuildContext context) {
    bool isRTL = AppLocalizations.of(context)!.isArLocale;

    DateTime parseDt = DateFormat('yyyy-MM-dd').parse(date);
    String formated = DateFormat.d(isRTL ? 'ar_SA' : 'en_US').format(parseDt);

    return formated;
  }

  static String getDayMonth(String date, BuildContext context) {
    bool isRTL = AppLocalizations.of(context)!.isArLocale;

    DateTime parseDt = DateFormat('yyyy-MM-dd').parse(date);
    String formated = DateFormat.yMMMd(
      isRTL ? 'ar_SA' : 'en_US',
    ).format(parseDt);

    return formated;
  }

  static String getAvailableDate(String date, BuildContext context) {
    bool isRTL = AppLocalizations.of(context)!.isArLocale;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    if (date.isNotEmpty) {
      DateTime parseDt = DateFormat('yyyy-MM-dd').parse(date);

      final aDate = DateTime(parseDt.year, parseDt.month, parseDt.day);
      if (aDate == today) {
        return AppLocalizations.of(context)!.text('today');
      } else if (aDate == tomorrow) {
        return AppLocalizations.of(context)!.text('tomorrow');
      } else {
        String formated = DateFormat.yMMMEd(
          isRTL ? 'ar_SA' : 'en_US',
        ).format(parseDt);
        return formated;
      }
    }
    return '';
  }

  static String getjm(String date, BuildContext context) {
    bool isRTL = AppLocalizations.of(context)!.isArLocale;

    DateTime parseDt = DateFormat('HH:mm:ss').parse(date);
    // String formated = DateFormat.jm(isRTL ? 'ar_SA' : 'en_US').format(parseDt);
    String formated = DateFormat(
      'hh:mm a',
      isRTL ? 'ar_SA' : 'en_US',
    ).format(parseDt);

    return formated;
  }

  static String getyMd(String date, BuildContext context) {
    bool isRTL = AppLocalizations.of(context)!.isArLocale;

    DateTime parseDt = DateFormat('yyyy-MM-dd HH:mm:ss').parse(date);
    String formated = DateFormat.yMMMd(
      isRTL ? 'ar_SA' : 'en_US',
    ).format(parseDt);
    return formated;
  }

  static String getHomeDate(String date, BuildContext context) {
    bool isRTL = AppLocalizations.of(context)!.isArLocale;

    DateTime parseDt = DateFormat('yyyy-MM-dd HH:mm:ss').parse(date);
    String formated = DateFormat.yMMMd(
      isRTL ? 'ar_SA' : 'en_US',
    ).format(parseDt);
    String day = DateFormat.EEEE(isRTL ? 'ar_SA' : 'en_US').format(parseDt);
    return '$formated ($day)';
  }

  static String getDayMonthTime(String date, BuildContext context) {
    bool isRTL = AppLocalizations.of(context)!.isArLocale;

    DateTime parseDt = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(date);
    String dateFormated = DateFormat.yMMMEd(
      isRTL ? 'ar_SA' : 'en_US',
    ).format(parseDt);
    String timeFormated = DateFormat.jm(
      isRTL ? 'ar_SA' : 'en_US',
    ).format(parseDt);
    String formated = '$dateFormated  $timeFormated';
    return formated;
  }

  static String getdateDiffrence(String date, String date2) {
    DateTime parseDt = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').parse(date);
    DateTime parseDt1 = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').parse(date2);
    int difference = parseDt1.difference(parseDt).inHours;
    return difference.toString();
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(
      Duration(days: DateTime.daysPerWeek - dateTime.weekday),
    );
  }

  String getFirstDayOfLast3Months() {
    DateTime now = DateTime.now();

    DateTime first = DateTime(now.year, now.month - 3, 1);

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(first);
    return formatted;
  }

  String getLastDayOfLast3Months() {
    DateTime now = DateTime.now();
    int lastday = DateTime(now.year, now.month, 0).day;
    DateTime last = DateTime(now.year, now.month - 1, lastday);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(last);
    return formatted;
  }

  String getFirstDayOfLastYear() {
    DateTime now = DateTime.now();

    DateTime first = DateTime(now.year - 1, 1, 1);

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(first);
    return formatted;
  }

  String getLastDayOfLastYear() {
    DateTime now = DateTime.now();
    DateTime last = DateTime(now.year - 1, 12, 31);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(last);
    return formatted;
  }

  String formateDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(date);
    return formatted;
  }

  String getFirstDayOfThisMonth() {
    final DateTime today = DateTime.now();
    final firstDay = DateTime(today.year, today.month, 1);
    final String fromDate = formateDate(firstDay);
    return fromDate;
  }

  String getLastDayOfThisMonth() {
    final DateTime today = DateTime.now();
    final String toDate = formateDate(today);
    return toDate;
  }

  String viewDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formatted = formatter.format(date);
    return formatted;
  }

  static String getYearMounthDay(String date, BuildContext context) {
    bool isRTL = AppLocalizations.of(context)!.isArLocale;

    DateTime parseDt = DateFormat('yyyy-MM-dd HH:mm:ss').parse(date);
    String formated = DateFormat.yMMMEd(
      isRTL ? 'ar_SA' : 'en_US',
    ).format(parseDt);
    return formated;
  }

  static String getRelativeTime(
    String? date,
    BuildContext context, {
    bool showSince = true,
  }) {
    if (date == null || date.isEmpty) return '';

    try {
      final now = DateTime.now();
      DateTime postedDate;

      // Try different date formats
      try {
        postedDate = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(date);
      } catch (e) {
        try {
          postedDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(date);
        } catch (e) {
          try {
            postedDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').parse(date);
          } catch (e) {
            return date; // Return original if parsing fails
          }
        }
      }

      final difference = now.difference(postedDate);
      final since = showSince
          ? AppLocalizations.of(context)!.text('since')
          : '';

      if (difference.inMinutes < 1) {
        return '$since ${AppLocalizations.of(context)!.text('now')}';
      } else if (difference.inMinutes < 60) {
        final minutes = difference.inMinutes;
        final minutesText = minutes == 1
            ? AppLocalizations.of(context)!.text('minute')
            : AppLocalizations.of(context)!.text('minutes');
        return '$since $minutes $minutesText';
      } else if (difference.inHours < 24) {
        final hours = difference.inHours;
        final hoursText = hours == 1
            ? AppLocalizations.of(context)!.text('hour')
            : AppLocalizations.of(context)!.text('hours');
        return '$since $hours $hoursText';
      } else if (difference.inDays < 7) {
        final days = difference.inDays;
        final daysText = days == 1
            ? AppLocalizations.of(context)!.text('day')
            : AppLocalizations.of(context)!.text('days');
        return '$since $days $daysText';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        final weeksText = weeks == 1
            ? AppLocalizations.of(context)!.text('week')
            : AppLocalizations.of(context)!.text('weeks');
        return '$since $weeks $weeksText';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        final monthsText = months == 1
            ? AppLocalizations.of(context)!.text('month')
            : AppLocalizations.of(context)!.text('months');
        return '$since $months $monthsText';
      } else {
        final years = (difference.inDays / 365).floor();
        final yearsText = years == 1
            ? AppLocalizations.of(context)!.text('year')
            : AppLocalizations.of(context)!.text('years');
        return '$since $years $yearsText';
      }
    } catch (e) {
      return date; // Return original if any error occurs
    }
  }

  /// Gets the next Friday date as a formatted string (yyyy-MM-dd)
  static String getNextFridayDate() {
    final now = DateTime.now();
    final currentWeekday = now.weekday; // 1 = Monday, 7 = Sunday

    // Calculate days until next Friday (5 = Friday)
    int daysUntilFriday;
    if (currentWeekday < 5) {
      // If it's Monday-Thursday, calculate days until this Friday
      daysUntilFriday = 5 - currentWeekday;
    } else if (currentWeekday == 5) {
      // If it's Friday, get next Friday (7 days)
      daysUntilFriday = 7;
    } else {
      // If it's Saturday or Sunday, calculate days until next Friday
      daysUntilFriday = 5 + (7 - currentWeekday);
    }

    final nextFriday = now.add(Duration(days: daysUntilFriday));
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(nextFriday);
  }

  /// Gets the next Friday DateTime object
  static DateTime getNextFridayDateTime() {
    final now = DateTime.now();
    final currentWeekday = now.weekday; // 1 = Monday, 7 = Sunday

    // Calculate days until next Friday (5 = Friday)
    int daysUntilFriday;
    if (currentWeekday < 5) {
      // If it's Monday-Thursday, calculate days until this Friday
      daysUntilFriday = 5 - currentWeekday;
    } else if (currentWeekday == 5) {
      // If it's Friday, get next Friday (7 days)
      daysUntilFriday = 7;
    } else {
      // If it's Saturday or Sunday, calculate days until next Friday
      daysUntilFriday = 5 + (7 - currentWeekday);
    }

    return now.add(Duration(days: daysUntilFriday));
  }

  /// Calculates the remaining time until next Friday
  /// Returns a map with 'days', 'hours', 'minutes', and 'seconds'
  static Map<String, int> getRemainingTimeUntilNextFriday() {
    final now = DateTime.now();
    final nextFriday = getNextFridayDateTime();

    // Set next Friday to end of day (23:59:59) for countdown
    final nextFridayEndOfDay = DateTime(
      nextFriday.year,
      nextFriday.month,
      nextFriday.day,
      23,
      59,
      59,
    );

    final difference = nextFridayEndOfDay.difference(now);

    // If the time has passed, return zeros
    if (difference.isNegative) {
      return {'days': 0, 'hours': 0, 'minutes': 0, 'seconds': 0};
    }

    final totalSeconds = difference.inSeconds;
    final days = totalSeconds ~/ (24 * 60 * 60);
    final hours = (totalSeconds % (24 * 60 * 60)) ~/ (60 * 60);
    final minutes = (totalSeconds % (60 * 60)) ~/ 60;
    final seconds = totalSeconds % 60;

    return {
      'days': days,
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
    };
  }

  /// Calculates remaining time for an auction with start/end times.
  /// When status is 'open': countdown to end_time (isClosing=true).
  /// When status is 'upcoming': countdown to start_time (isClosing=false).
  static Map<String, dynamic> getAuctionRemainingTimeFromTimes(
    String startTime,
    String endTime,
    String status,
  ) {
    final target = status == 'open' ? endTime : startTime;
    final isClosing = status == 'open';
    final remaining = getRemainingTime(target);
    return {
      ...remaining,
      'isClosing': isClosing,
    };
  }

  /// Calculates the remaining time until a specific datetime string
  /// Returns a map with 'days', 'hours', 'minutes', and 'seconds'
  static Map<String, int> getRemainingTime(String targetDateTimeStr) {
    final now = DateTime.now();

    try {
      // Parse the target datetime (format: 2025-12-05T07:00:00.000000Z)
      DateTime targetDateTime;
      try {
        targetDateTime = DateTime.parse(targetDateTimeStr);
      } catch (e) {
        // If parsing fails, return zeros
        return {'days': 0, 'hours': 0, 'minutes': 0, 'seconds': 0};
      }

      final difference = targetDateTime.difference(now);

      // If the time has passed, return zeros
      if (difference.isNegative) {
        return {'days': 0, 'hours': 0, 'minutes': 0, 'seconds': 0};
      }

      final totalSeconds = difference.inSeconds;
      final days = totalSeconds ~/ (24 * 60 * 60);
      final hours = (totalSeconds % (24 * 60 * 60)) ~/ (60 * 60);
      final minutes = (totalSeconds % (60 * 60)) ~/ 60;
      final seconds = totalSeconds % 60;

      return {
        'days': days,
        'hours': hours,
        'minutes': minutes,
        'seconds': seconds,
      };
    } catch (e) {
      return {'days': 0, 'hours': 0, 'minutes': 0, 'seconds': 0};
    }
  }

  /// Gets the next Friday at 7:00 AM
  static DateTime getNextFriday7AM() {
    final now = DateTime.now();
    final currentWeekday = now.weekday; // 1 = Monday, 7 = Sunday

    // Calculate days until next Friday (5 = Friday)
    int daysUntilFriday;
    if (currentWeekday < 5) {
      // If it's Monday-Thursday, calculate days until this Friday
      daysUntilFriday = 5 - currentWeekday;
    } else if (currentWeekday == 5) {
      // If it's Friday, check if it's before 7 AM
      if (now.hour < 7) {
        // Today is Friday and before 7 AM, return today at 7 AM
        return DateTime(now.year, now.month, now.day, 7, 0, 0);
      } else {
        // Today is Friday and after 7 AM, get next Friday (7 days)
        daysUntilFriday = 7;
      }
    } else {
      // If it's Saturday or Sunday, calculate days until next Friday
      daysUntilFriday = 5 + (7 - currentWeekday);
    }

    final nextFriday = now.add(Duration(days: daysUntilFriday));
    return DateTime(nextFriday.year, nextFriday.month, nextFriday.day, 7, 0, 0);
  }

  /// Gets the current Friday at 10:00 PM
  static DateTime? getCurrentFriday10PM() {
    final now = DateTime.now();
    final currentWeekday = now.weekday; // 1 = Monday, 7 = Sunday

    // Only return if today is Friday
    if (currentWeekday == 5) {
      // Today is Friday, return today at 10:00 PM
      return DateTime(now.year, now.month, now.day, 22, 0, 0);
    }

    return null; // Not Friday
  }

  /// Calculates remaining time for auction (opening or closing)
  /// Returns a map with 'days', 'hours', 'minutes', 'seconds', and 'isClosing'
  /// Opening: 7 AM on Friday
  /// Closing: 10 PM on Friday
  static Map<String, dynamic> getAuctionRemainingTime() {
    final now = DateTime.now();
    final currentWeekday = now.weekday;

    // Check if today is Friday
    if (currentWeekday == 5) {
      // Today is Friday
      final today7AM = DateTime(now.year, now.month, now.day, 7, 0, 0);
      final today10PM = DateTime(now.year, now.month, now.day, 22, 0, 0);

      if (now.isBefore(today7AM)) {
        // Before 7 AM on Friday - countdown to opening
        final difference = today7AM.difference(now);
        return _calculateTimeDifference(difference, isClosing: false);
      } else if (now.isBefore(today10PM)) {
        // Between 7 AM and 10 PM on Friday - countdown to closing
        final difference = today10PM.difference(now);
        return _calculateTimeDifference(difference, isClosing: true);
      } else {
        // After 10 PM on Friday - countdown to next Friday opening
        final nextFriday7AM = getNextFriday7AM();
        final difference = nextFriday7AM.difference(now);
        return _calculateTimeDifference(difference, isClosing: false);
      }
    } else {
      // Not Friday - countdown to next Friday opening
      final nextFriday7AM = getNextFriday7AM();
      final difference = nextFriday7AM.difference(now);
      return _calculateTimeDifference(difference, isClosing: false);
    }
  }

  /// Helper method to calculate time difference
  static Map<String, dynamic> _calculateTimeDifference(
    Duration difference, {
    required bool isClosing,
  }) {
    // If the time has passed, return zeros
    if (difference.isNegative) {
      return {
        'days': 0,
        'hours': 0,
        'minutes': 0,
        'seconds': 0,
        'isClosing': false,
      };
    }

    final totalSeconds = difference.inSeconds;
    final days = totalSeconds ~/ (24 * 60 * 60);
    final hours = (totalSeconds % (24 * 60 * 60)) ~/ (60 * 60);
    final minutes = (totalSeconds % (60 * 60)) ~/ 60;
    final seconds = totalSeconds % 60;

    return {
      'days': days,
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
      'isClosing': isClosing,
    };
  }
}
