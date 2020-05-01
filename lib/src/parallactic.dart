// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

// Parallactic: Chapter 14, The Parallactic Angle, and three other Topics.

import 'dart:math' as math;

import 'package:unit/unit.dart' as unit;

// // ParallacticAngle returns parallactic angle of a celestial object.
// //
// //	phi is geographic latitude of observer.
// //	delta is declination of observed object.
// //	H is hour angle of observed object.
// func ParallacticAngle(phi, delta unit.Angle, H unit.HourAngle) unit.Angle {
// 	sdelta, cdelta := delta.Sincos()
// 	sH, cH := H.Sincos()
// 	// (14.1) p. 98
// 	return unit.Angle(math.Atan2(sH, phi.Tan()*cdelta-sdelta*cH))
// }

// // ParallacticAngleOnHorizon is a special case of ParallacticAngle.
// //
// // The hour angle is not needed as an input and the math inside simplifies.
// func ParallacticAngleOnHorizon(phi, delta unit.Angle) unit.Angle {
// 	return unit.Angle(math.Acos(phi.Sin() / delta.Cos()))
// }

/// EclipticAtHorizon computes how the plane of the ecliptic intersects
/// the horizon at a given local sidereal time as observed from a given
/// geographic latitude.
///
///	[epsilon] is obliquity of the ecliptic.
///	[phi] is geographic latitude of observer.
///	[theta] is local sidereal time.
EclipticAtHorizon eclipticAtHorizon(
    unit.Angle epsilon, unit.Angle phi, unit.Time theta) {
  final sinEpsilon = epsilon.sin();
  final cosEpsilon = epsilon.cos();
  final sinPhi = phi.sin();
  final cosPhi = phi.cos();
  final thetaAngle = theta.angle();
  final sinTheta = thetaAngle.sin();
  final cosTheta = thetaAngle.cos();
  // (14.2) p. 99
  var lambda = unit.Angle(math.atan2(
      -cosTheta, sinEpsilon * (sinPhi / cosPhi) + cosEpsilon * sinTheta));
  if (lambda < unit.Angle(0)) {
    lambda += unit.Angle(math.pi);
  }
  // (14.3) p. 99
  return EclipticAtHorizon(
      lambda,
      lambda + unit.Angle(math.pi),
      unit.Angle(
          math.acos(cosEpsilon * sinPhi - sinEpsilon * cosPhi * sinTheta)));
}

class EclipticAtHorizon {
  /// Ecliptic longitude where the ecliptic intersects the horizon.
  final unit.Angle lambda1;

  /// Ecliptic longitude where the ecliptic intersects the horizon.
  final unit.Angle lambda2;

  // Angle at which the ecliptic intersects the horizon
  final unit.Angle i;

  const EclipticAtHorizon(this.lambda1, this.lambda2, this.i);
}

/// EclipticAtEquator computes the angle between the ecliptic and the parallels
/// of ecliptic latitude at a given ecliptic longitude.
///
/// (The function name EclipticAtEquator is for consistency with the Meeus text,
/// and works if you consider the equator a nominal parallel of latitude.)
///
///	[lambda] is ecliptic longitude.
///	[epsilon] is obliquity of the ecliptic.
unit.Angle eclipticAtEquator(unit.Angle lambda, unit.Angle epsilon) {
  return unit.Angle(math.atan(-lambda.cos() * epsilon.tan()));
}

/// DiurnalPathAtHorizon computes the angle of the path a celestial object
/// relative to the horizon at the time of its rising or setting.
///
///	[delta] is declination of the object.
///	[phi] is geographic latitude of observer.
unit.Angle diurnalPathAtHorizon(unit.Angle delta, unit.Angle phi) {
  final tphi = phi.tan();
  final b = delta.tan() * tphi;
  final c = math.sqrt(1 - b * b);
  return unit.Angle(math.atan(c * delta.cos() / tphi));
}
