// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

import 'package:test/test.dart';

import 'package:meeus/julian.dart' as julian;

void main() {
  group('Julian', () {
    setUp(() {});

    test('CalendarGregorianToJD_sputnik', () {
      // Example 7.a, p. 61.
      final jd = julian.calendarGregorianToJD(1957, 10, 4.81);
      expect(jd, closeTo(2436116.31, 1e-2));
    });

    test('CalendarGregorianToJD_halley', () {
      // Example 7.d, p. 64.
      final jd1 = julian.calendarGregorianToJD(1910, 4, 20);
      final jd2 = julian.calendarGregorianToJD(1986, 2, 9);
      expect(jd2 - jd1, 27689);
    });
  });

  group('DateTime', () {
    test('DateTimeToJD_sputnik UTC', () {
      final dt = DateTime.utc(1957, 10, 4, 19, 28, 34);

      expect(julian.dateTimeToJD(dt), closeTo(2436116.31150, 1e-5));
    });

    test('DateTimeToJD_sputnik Local should ignore TZ', () {
      final dt = DateTime(1957, 10, 4, 19, 28, 34);

      expect(julian.dateTimeToJD(dt), closeTo(2436116.31150, 1e-5));
    });
  });
}
