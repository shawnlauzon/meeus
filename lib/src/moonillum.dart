// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

import 'dart:math' as math;

import 'package:unit/unit.dart' as unit;

import 'base.dart' as base;

// // PhaseAngleEQ computes the phase angle of the Moon given equatorial coordinates.
// //
// // Arguments α, δ, Δ are geocentric right ascension, declination, and distance
// // to the Moon; α0, δ0, R  are coordinates of the Sun.  Angles must be in
// // radians.  Distances must be in the same units as each other.
// func PhaseAngleEq(α unit.RA, δ unit.Angle, Δ float64, α0 unit.RA, δ0 unit.Angle, R float64) unit.Angle {
// 	return pa(Δ, R, cψEq(α, α0, δ, δ0))
// }

// // cos elongation from equatorial coordinates
// func cψEq(α, α0 unit.RA, δ, δ0 unit.Angle) float64 {
// 	// 48.2, p. 345
// 	sδ, cδ := δ.Sincos()
// 	sδ0, cδ0 := δ0.Sincos()
// 	return sδ0*sδ + cδ0*cδ*(α0-α).Cos()
// }

// // phase angle from cos elongation and distances
// func pa(Δ, R, cψ float64) unit.Angle {
// 	// 48.3, p. 346
// 	sψ := math.Sin(math.Acos(cψ))
// 	i := unit.Angle(math.Atan2(R*sψ, Δ-R*cψ))
// 	return i
// }

// // PhaseAngleEQ2 computes the phase angle of the Moon given equatorial coordinates.
// //
// // Less accurate than PhaseAngleEq.
// //
// // Arguments α, δ are geocentric right ascension and declination of the Moon;
// // α0, δ0  are coordinates of the Sun.
// func PhaseAngleEq2(α unit.RA, δ unit.Angle, α0 unit.RA, δ0 unit.Angle) unit.Angle {
// 	return unit.Angle(math.Acos(-cψEq(α, α0, δ, δ0)))
// }

// // PhaseAngleEcl computes the phase angle of the Moon given ecliptic coordinates.
// //
// // Arguments λ, β, Δ are geocentric longitude, latitude, and distance
// // to the Moon; λ0, R  are longitude and distance to the Sun.
// // Distances must be in the same units as each other.
// func PhaseAngleEcl(λ, β unit.Angle, Δ float64, λ0 unit.Angle, R float64) unit.Angle {
// 	return pa(Δ, R, cψEcl(λ, β, λ0))
// }

// // cos elongation from ecliptic coordinates
// func cψEcl(λ, β, λ0 unit.Angle) float64 {
// 	// 48.2, p. 345
// 	return math.Cos(β.Rad()) * math.Cos((λ - λ0).Rad())
// }

// // PhaseAngleEcl2 computes the phase angle of the Moon given ecliptic coordinates.
// //
// // Less accurate than PhaseAngleEcl.
// //
// // Arguments λ, β are geocentric longitude and latitude of the Moon;
// // λ0 is longitude of the Sun.
// func PhaseAngleEcl2(λ, β, λ0 unit.Angle) unit.Angle {
// 	return unit.Angle(math.Acos(-cψEcl(λ, β, λ0)))
// }

/// Computes the phase angle of the Moon given a julian day.
///
/// Less accurate than PhaseAngle functions taking coordinates.
unit.Angle phaseAngle3(num jde) {
  final T = base.j2000Century(jde);
  final D = unit.Angle.fromDeg(base.horner(T, [
    297.8501921,
    445267.1114034,
    -.0018819,
    1 / 545868,
    -1 / 113065000
  ])).mod1().rad;
  final M = unit.Angle.fromDeg(
          base.horner(T, [357.5291092, 35999.0502909, -.0001535, 1 / 24490000]))
      .mod1()
      .rad;
  final Mprime = unit.Angle.fromDeg(base.horner(
          T, [134.9633964, 477198.8675055, .0087414, 1 / 69699, -1 / 14712000]))
      .mod1()
      .rad;
  return unit.Angle(math.pi) -
      unit.Angle(D) +
      unit.Angle.fromDeg(-6.289 * math.sin(Mprime) +
          2.1 * math.sin(M) +
          -1.274 * math.sin(2 * D - Mprime) +
          -.658 * math.sin(2 * D) +
          -.214 * math.sin(2 * Mprime) +
          -.11 * math.sin(D));
}
