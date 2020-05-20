// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

import 'package:test/test.dart';

import 'package:meeus/moonphase.dart' as moonphase;

void main() {
  group('Moon Phase', () {
    setUp(() {});

    test('Mean New Moon', () {
      // Example 49.a, p. 353.
      expect(moonphase.meanNewMoon(1977.13), closeTo(2443192.94102, 1e-5));
    });

    test('New Moon', () {
      // Example 49.a, p. 353.
      expect(moonphase.newMoon(1977.13), closeTo(2443192.65118, 1e-5));
    });

    test('Mean Last', () {
      // Example 49.b, p. 353.
      expect(moonphase.meanLast(2044.04), closeTo(2467636.88597, 1e-5));
    });

    test('Last', () {
      // Example 49.b, p. 353.
      expect(moonphase.last(2044.04), closeTo(2467636.49186, 1e-5));
    });
  });
}
