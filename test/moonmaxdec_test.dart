// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

import 'package:test/test.dart';

import 'package:meeus/julian.dart' as julian;
import 'package:meeus/moonmaxdec.dart' as moonmaxdec;

import 'test_utils.dart';

void main() {
  group('Moon Maximum Declination', () {
    setUp(() {});

    test('Example North', () {
      // Example 52.a, p. 370.
      final declination = moonmaxdec.north(1988.95);
      expect(declination.jde, closeTo(2447518.3346, 1e-4));
      final dt = julian.jdToDateTime(declination.jde);
      expect(
          dt,
          closeToDateTime(
              DateTime.utc(1988, 12, 22, 20, 02), Duration(minutes: 1)));
      expect(declination.delta.deg, closeTo(28.1562, 1e-4));
    });

    test('Example South', () {
      // Example 52.b, p. 370.
      final declination = moonmaxdec.south(2049.3);
      expect(declination.jde, closeTo(2469553.0834, 1e-4));
      final dt = julian.jdToDateTime(declination.jde);
      expect(dt,
          closeToDateTime(DateTime.utc(2049, 4, 21, 14), Duration(minutes: 1)));
      expect(declination.delta.deg, closeTo(-22.1384, 1e-4));
    });
  });
}
