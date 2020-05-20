// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

import 'base.dart' as base;

/// CalendarGregorianToJD converts a Gregorian year, month, and day of month
/// to Julian day.
///
/// Negative years are valid, back to JD 0.  The result is not valid for
/// dates before JD 0.
num calendarGregorianToJD(int y, int m, num d) {
  switch (m) {
    case 1:
    case 2:
      y--;
      m += 12;
  }
  final a = base.floorDiv(y, 100);
  final b = 2 - a + base.floorDiv(a, 4);
  // (7.1) p. 61
  return (base.floorDiv(36525 * (y + 4716), 100)) +
      (base.floorDiv(306 * (m + 1), 10) + b) +
      d -
      1524.5;
}

/// Returns the Gregorian calendar date for the given jd.
///
/// Note that it returns a Gregorian date even for dates before the start of
/// the Gregorian calendar.
Calendar jdToCalendar(num jd) {
  final modfResult = base.modf(jd + .5);
  final z = modfResult.intPart;
  var a = z;
  var alpha;
  if (z >= 2299151) {
    alpha = base.floorDiv(z * 100 - 186721625, 3652425);
    a = z + 1 + alpha - base.floorDiv(alpha, 4);
  }
  final b = a + 1524;
  final c = base.floorDiv(b * 100 - 12210, 36525);
  final d = base.floorDiv(36525 * c, 100);
  final e = base.floorDiv(((b - d) * 1e4).truncate(), 306001);
  // compute return values
  final day = ((b - d) - base.floorDiv(306001 * e, 1e4)) + modfResult.fracPart;
  var month, year;
  switch (e) {
    case 14:
    case 15:
      month = e - 13;
      break;
    default:
      month = e - 1;
  }
  switch (month) {
    case 1:
    case 2:
      year = c - 4715;
      break;
    default:
      year = c - 4716;
  }
  return Calendar(year, month, day);
}

class Calendar {
  final int year;
  final int month;
  final num day;

  const Calendar(this.year, this.month, this.day);
}

Calendar jdToCalendarGregorian(num jd) {
  final modfResult = base.modf(jd + .5);
  final z = modfResult.intPart;
  final alpha = base.floorDiv(z * 100 - 186721625, 3652425);
  final a = z + 1 + alpha - base.floorDiv(alpha, 4);
  final b = a + 1524;
  final c = base.floorDiv(b * 100 - 12210, 36525);
  final d = base.floorDiv(36525 * c, 100);
  final e = base.floorDiv(((b - d) * 1e4).truncate(), 306001);
  // compute return values
  final day = ((b - d) - base.floorDiv(306001 * e, 1e4)) + modfResult.fracPart;
  var month, year;
  switch (e) {
    case 14:
    case 15:
      month = e - 13;
      break;
    default:
      month = e - 1;
  }
  switch (month) {
    case 1:
    case 2:
      year = c - 4715;
      break;
    default:
      year = c - 4716;
  }
  return Calendar(year, month, day);
}

/// Takes a JD and returns a Dart DateTime value.
DateTime jdToDateTime(num jd) {
  // DateTime is always Gregorian
  final cal = jdToCalendarGregorian(jd);
  final dt = DateTime.utc(cal.year, cal.month, 0, 0, 0, 0, 0);
  return dt.add(
      Duration(seconds: (cal.day * 24 * Duration.secondsPerHour).truncate()));
}

/// Takes a Dart core.DateTime and returns a JD as a num.
///
/// Any time zone offset in the DateTime is ignored and the time is
/// treated as UTC.
num dateTimeToJD(DateTime dt) {
  var ut = dt.toUtc();
  var d = ut.difference(DateTime.utc(dt.year, dt.month, 0, 0, 0, 0, 0));
  // time.Time is always Gregorian
  return calendarGregorianToJD(dt.year, dt.month,
      d.inMilliseconds / (24 * Duration.millisecondsPerHour));
}
