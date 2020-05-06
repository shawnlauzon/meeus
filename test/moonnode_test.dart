// Copyright 2013 Sonia Keys
// License: MIT

import 'package:test/test.dart';

import 'package:unit/unit.dart' as unit;

import 'package:meeus/julian.dart' as julian;
import 'package:meeus/base.dart' as base;
import 'package:meeus/moonnode.dart' as moonnode;

import 'test_utils.dart';

void main() {
  group('Moon node', () {
    test('ExampleAscending', () {
      // Example 51.a, p. 365.
      final j = moonnode.ascending(1987.37);
      expect(j, closeTo(2446938.76803, precision5));
      final calendar = julian.jdToCalendar(j);
      final result = base.modf(calendar.day);
      expect(calendar.year, 1987);
      expect(calendar.month, 5);
      expect(result.intPart, 23);
      expect(
          unit.Time.fromDay(result.fracPart), unit.Time.fromSexa(0, 6, 25, 58));
      // 1987 May 23, at 6ʰ25ᵐ58ˢ TD
    });
  });
}
