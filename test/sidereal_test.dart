// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

import 'package:test/test.dart';

import 'package:meeus/julian.dart' as julian;
import 'package:meeus/sidereal.dart' as sidereal;

void main() {
  group('Sidereal', () {
    setUp(() {});

    test('Example Mean_a', () {
      // Example 12.a, p. 88.
      final jd = 2446895.5;
      final s = sidereal.mean(jd);
      final sa = sidereal.apparent(jd);

      expect(s.toIso8601String(), '13:10:46.366827');
      expect(sa.toIso8601String(), '13:10:46.135144');

      // Output:
      // 13ʰ10ᵐ46ˢ.3668
      // 13ʰ10ᵐ46ˢ.1351
    });

    test('Example Mean_b', () {
      // Example 12.b, p. 89.
      final jd = julian.dateTimeToJD(DateTime.utc(1987, 4, 10, 19, 21, 0, 0));
      expect(sidereal.mean(jd).toIso8601String(), '8:34:57.089584');
      // Output:
      // 8ʰ34ᵐ57ˢ.0896
    });
  });
}
