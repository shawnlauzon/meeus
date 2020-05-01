// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

import 'package:test/test.dart';

import 'package:meeus/meeus.dart';

import 'test_utils.dart';

void main() {
  group('Julian', () {
    setUp(() {});

    test('CalendarGregorianToJD_sputnik', () {
      // Example 7.a, p. 61.
      final jd = calendarGregorianToJD(1957, 10, 4.81);
      expect(jd, closeTo(2436116.31, precision2));
    });

    test('CalendarGregorianToJD_halley', () {
      // Example 7.c, p. 64.
      final jd1 = calendarGregorianToJD(1910, 4, 20);
      final jd2 = calendarGregorianToJD(1986, 2, 9);
      expect(jd2 - jd1, 27689);
    });
  });
}
