// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

import 'package:test/test.dart';

import 'package:meeus/base.dart' as base;
import 'package:meeus/julian.dart' as julian;
import 'package:meeus/solar.dart' as solar;
import 'package:unit/unit.dart' as unit;

void main() {
  group('Solar', () {
    setUp(() {});

    test('True', () {
      // Example 25.a, p. 165.
      final jd = julian.calendarGregorianToJD(1992, 10, 13);
      expect(jd, 2448908.5);
      final t = base.j2000Century(jd);
      expect(t, closeTo(-0.072183436, 1e-9));
      final sv = solar.trueCoordinates(t);
      expect(sv.s.deg, closeTo(199.90987, 1e-5));
    });

    test('Mean Anomaly', () {
      // Example 25.a, p. 165.
      final T = base.j2000Century(julian.calendarGregorianToJD(1992, 10, 13));
      expect(solar.meanAnomaly(T).deg, closeTo(-2241.00603, 1e-5));
    });

    test('Eccentricity', () {
      // Example 25.a, p. 165.
      final T = base.j2000Century(julian.calendarGregorianToJD(1992, 10, 13));
      expect(solar.eccentricity(T), closeTo(0.016711668, 1e-9));
    });

    test('Radius', () {
      // Example 25.a, p. 165.
      final T = base.j2000Century(julian.calendarGregorianToJD(1992, 10, 13));
      expect(solar.radius(T), closeTo(0.99766, 1e-5));
    });

    test('Apparent Longitude', () {
      // Example 25.a, p. 165.
      final T = base.j2000Century(julian.calendarGregorianToJD(1992, 10, 13));
      expect(solar.apparentLongitude(T).deg,
          closeTo(unit.Angle(unit.fromSexa(' ', 199, 54, 32)).rad, 1e-4));
    });

// func ExampleApparentEquatorial() {
// 	// Example 25.a, p. 165.
// 	jde := julian.CalendarGregorianToJD(1992, 10, 13)
// 	α, δ := solar.ApparentEquatorial(jde)
// 	fmt.Printf("α: %.1d\n", sexa.FmtRA(α))
// 	fmt.Printf("δ: %d\n", sexa.FmtAngle(δ))
// 	// Output:
// 	// α: 13ʰ13ᵐ31ˢ.4
// 	// δ: -7°47′6″
// }
  });
}
