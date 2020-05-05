// Copyright 2013 Sonia Keys
// License: MIT

import 'package:test/test.dart';

import 'package:unit/unit.dart' as unit;

import 'package:meeus/apsis.dart' as apsis;
import 'package:meeus/julian.dart' as julian;
import 'package:meeus/base.dart' as base;
import 'package:meeus/moonposition.dart' as moonposition;

import 'test_utils.dart';

void main() {
  group('Apogee', () {
    test('ExampleMeanApogee', () {
      expect(apsis.meanApogee(1988.75), closeTo(2447442.8191, precision4));
    });

    test('ExampleApogee', () {
      // Example 50.a, p. 357.
      final j = apsis.apogee(1988.75);
      expect(j, closeTo(2447442.3543, precision4));
      final calendar = julian.jdToCalendar(j);
      final result = base.modf(calendar.day);
      expect(calendar.year, 1988);
      expect(calendar.month, 10);
      expect(result.intPart, 7);
      expect(unit.Time.fromDay(result.fracPart).toIso8601String(),
          startsWith('20:30'));
      // 1988 October 7, at 20ʰ30ᵐ TD
    });

    test('ExampleApogeeParallax', () {
      // Example 50.a, p. 357.
      final p = apsis.apogeeParallax(1988.75);
      expect(p.sec, closeTo(3240.679, precision3));
      expect(p, unit.Angle.fromSexa(0, 0, 54, .679));
    });
  });

  group('Perigee', () {
    test('TestPerigee', () {
      const data = [
        PerigeeData(1997, 12, 9 + 16.9 / 24, 1997.93),
        PerigeeData(1998, 1, 3 + 8.5 / 24, 1998.01),
        PerigeeData(1990, 12, 2 + 10.8 / 24, 1990.92),
        PerigeeData(1990, 12, 30 + 23.8 / 24, 1991)
      ];

      data.forEach((c) {
        final ref = julian.calendarGregorianToJD(c.y, c.m, c.d);
        final j = apsis.perigee(c.dy);
        expect(j, closeTo(ref, precision1));
      });
    });

    // Lacking a worked example from the text, test using meeus/moonposition.
    test('TestPerigeeParallax', () {
      final got = apsis.perigeeParallax(1997.93);
      final pos = moonposition.position(apsis.perigee(1997.93));
      final want = moonposition.parallax(pos.delta);

      // for this case anyway it's within a tenth of an arc second
      expect(got.rad, closeTo(want.rad, precision1));
    });
  });
}

class PerigeeData {
  final int y;
  final int m;
  final num d;
  final num dy;

  const PerigeeData(this.y, this.m, this.d, this.dy);
}
