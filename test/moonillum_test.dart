// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

import 'package:test/test.dart';

import 'package:meeus/base.dart' as base;
import 'package:meeus/julian.dart' as julian;
import 'package:meeus/moonillum.dart' as moonillum;

import 'package:meeus/meeus.dart' show meanNewMoon;

import 'test_utils.dart';

void main() {
  group('Moon Illumination', () {
    setUp(() {});

// func ExamplePhaseAngleEq() {
// 	i := moonillum.PhaseAngleEq(
// 		unit.RAFromDeg(134.6885),
// 		unit.Angle.fromDeg(13.7684),
// 		368410,
// 		unit.RAFromDeg(20.6579),
// 		unit.Angle.fromDeg(8.6964),
// 		149971520)
// 	fmt.Printf("i = %.4f\n", i.Deg())
// 	// Output:
// 	// i = 69.0756
// }

// func ExamplePhaseAngleEq2() {
// 	i := moonillum.PhaseAngleEq2(
// 		unit.RAFromDeg(134.6885),
// 		unit.Angle.fromDeg(13.7684),
// 		unit.RAFromDeg(20.6579),
// 		unit.Angle.fromDeg(8.6964))
// 	k := base.Illuminated(i)
// 	fmt.Printf("k = %.4f\n", k)
// 	// Output:
// 	// k = 0.6775
// }

// func TestPhaseAngleEcl(t *testing.T) {
// 	j := julian.CalendarGregorianToJD(1992, 4, 12)
// 	λ, β, Δ := moonposition.Position(j)
// 	T := base.J2000Century(j)
// 	λ0 := solar.ApparentLongitude(T)
// 	R := solar.Radius(T) * base.AU
// 	i := moonillum.PhaseAngleEcl(λ, β, Δ, λ0, R)
// 	ref := unit.Angle.fromDeg(69.0756)
// 	if math.Abs(((i - ref) / ref).Rad()) > 1e-4 {
// 		t.Errorf("i = %.4f", i.Deg())
// 	}
// }

// func TestPhaseAngleEcl2(t *testing.T) {
// 	j := julian.CalendarGregorianToJD(1992, 4, 12)
// 	λ, β, _ := moonposition.Position(j)
// 	λ0 := solar.ApparentLongitude(base.J2000Century(j))
// 	i := moonillum.PhaseAngleEcl2(λ, β, λ0)
// 	k := base.Illuminated(i)
// 	ref := .6775
// 	if math.Abs(k-ref) > 1e-4 {
// 		t.Errorf("k = %.4f", k)
// 	}
// }

    test('PhaseAngle3', () {
      final i =
          moonillum.phaseAngle3(julian.calendarGregorianToJD(1992, 4, 12));
      final k = base.illuminated(i);
      expect(i.deg, closeTo(68.88, precision2));
      expect(k, closeTo(0.6801, precision4));
    });
  });
}
