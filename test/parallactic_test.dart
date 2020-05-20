// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

import 'dart:math' as math;

import 'package:test/test.dart';

import 'package:unit/unit.dart' as unit;
import 'package:meeus/parallactic.dart' as parallactic;

import 'test_utils.dart';

void main() {
  group('Parallactic', () {
    setUp(() {});

    test('Example Ecliptic at Horizon', () {
      final epsilon = unit.Angle.fromDeg(23.44);
      final phi = unit.Angle.fromDeg(51);
      final theta = unit.Time.fromHour(5);
      final result = parallactic.eclipticAtHorizon(epsilon, phi, theta);

      expect(
          result.lambda1,
          closeToAngle(unit.Angle.fromSexa('', 169, 21, 30),
              const unit.Angle.fromDeg(1)));
      expect(
          result.lambda2,
          closeToAngle(unit.Angle.fromSexa('', 349, 21, 30),
              const unit.Angle.fromDeg(1)));
      expect(
          result.i,
          closeToAngle(unit.Angle.fromSexa('', 61, 53, 14),
              const unit.Angle.fromDeg(1)));
    });

    test('Diurnal path at Horizon', () {
      final phi = unit.Angle.fromDeg(40);
      final epsilon = unit.Angle.fromDeg(23.44);
      var J = parallactic.diurnalPathAtHorizon(unit.Angle(0), phi);
      var Jexp = unit.Angle(math.pi / 2) - phi;
      if (((J - Jexp).rad / Jexp.rad).abs() > 1e-15) {
        fail('0 dec: ${J.deg}');
      }
      J = parallactic.diurnalPathAtHorizon(epsilon, phi);
      Jexp = unit.Angle.fromSexa(' ', 45, 31, 0);
      if (((J - Jexp).rad / Jexp.rad).abs() > 1e-3) {
        fail('solstice: ${J.deg}');
      }
    });
  });
}
