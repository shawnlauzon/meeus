// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

// Solar: Chapter 25, Solar Coordinates.

import 'package:unit/unit.dart' as unit;

import 'base.dart' as base;

/// True returns true geometric longitude and anomaly of the sun referenced to the mean equinox of date.
///
/// Argument [t] is the number of Julian centuries since J2000.
/// See base.J2000Century.
True trueCoordinates(num t) {
  /// (25.2) p. 163
  final L0 =
      unit.Angle.fromDeg(base.horner(t, [280.46646, 36000.76983, 0.0003032]));
  final M = meanAnomaly(t);
  final C = unit.Angle.fromDeg(
      base.horner(t, [1.914602, -0.004817, -.000014]) * M.sin() +
          (0.019993 - .000101 * t) * M.mul(2).sin() +
          0.000289 * M.mul(3).sin());
  return True((L0 + C).mod1(), (M + C).mod1());
}

class True {
  final unit.Angle s; // true geometric longitude, ☉
  final unit.Angle v; // true anomaly

  const True(this.s, this.v);
}

/// Returns the mean anomaly of Earth at the given t.
///
/// Argument [t] is the number of Julian centuries since J2000.
/// See base.J2000Century.
///
/// Result is not normalized to the range 0..2π.
unit.Angle meanAnomaly(num t) {
  // (25.3) p. 163
  return unit.Angle.fromDeg(
      base.horner(t, [357.52911, 35999.05029, -0.0001537]));
}

/// Returns eccentricity of the Earth's orbit around the sun.
///
/// Argument [t] is the number of Julian centuries since J2000.
/// See base.J2000Century.
double eccentricity(double t) {
  // (25.4) p. 163
  return base.horner(t, [0.016708634, -0.000042037, -0.0000001267]);
}

/// Returns the Sun-Earth distance in AU.
///
/// Argument [t] is the number of Julian centuries since J2000.
/// See base.J2000Century.
double radius(double t) {
  final result = trueCoordinates(t);
  final e = eccentricity(t);
  // (25.5) p. 164
  return 1.000001018 * (1 - e * e) / (1 + e * result.v.cos());
}

/// Returns apparent longitude of the Sun referenced
/// to the true equinox of date.
///
/// Argument [t] is the number of Julian centuries since J2000.
/// See base.J2000Century.
///
/// Result includes correction for nutation and aberration.
unit.Angle apparentLongitude(num t) {
  final omega = node(t);
  final sv = trueCoordinates(t);
  return sv.s -
      unit.Angle.fromDeg(.00569) -
      unit.Angle.fromDeg(.00478).mul(omega.sin());
}

unit.Angle node(double t) {
  return unit.Angle.fromDeg(125.04 - 1934.136 * t);
}

// // True2000 returns true geometric longitude and anomaly of the sun referenced to equinox J2000.
// //
// // Argument t is the number of Julian centuries since J2000.
// // See base.J2000Century.
// //
// // Results are accurate to .01 degree for years 1900 to 2100.
// //
// // Results:
// //	s = true geometric longitude, ☉
// //	ν = true anomaly
// func True2000(t float64) (s, ν unit.Angle) {
// 	s, ν = True(t)
// 	s -= unit.Angle.fromDeg(.01397).Mul(t * 100)
// 	return
// }

// // TrueEquatorial returns the true geometric position of the Sun as equatorial coordinates.
// func TrueEquatorial(jde float64) (α unit.RA, δ unit.Angle) {
// 	s, _ := True(base.J2000Century(jde))
// 	ε := nutation.MeanObliquity(jde)
// 	ss, cs := s.Sincos()
// 	sε, cε := ε.Sincos()
// 	// (25.6, 25.7) p. 165
// 	α = unit.RAFromRad(math.Atan2(cε*ss, cs))
// 	δ = unit.Angle(math.Asin(sε * ss))
// 	return
// }

// // ApparentEquatorial returns the apparent position of the Sun as equatorial coordinates.
// //
// //	α: right ascension in radians
// //	δ: declination in radians
// func ApparentEquatorial(jde float64) (α unit.RA, δ unit.Angle) {
// 	t := base.J2000Century(jde)
// 	λ := ApparentLongitude(t)
// 	ε := nutation.MeanObliquity(jde)
// 	sλ, cλ := λ.Sincos()
// 	// (25.8) p. 165
// 	ε += unit.Angle.fromDeg(.00256).Mul(node(t).Cos())
// 	sε, cε := ε.Sincos()
// 	α = unit.RAFromRad(math.Atan2(cε*sλ, cλ))
// 	δ = unit.Angle(math.Asin(sε * sλ))
// 	return
// }

// // TrueVSOP87 returns the true geometric position of the sun as ecliptic coordinates.
// //
// // Result computed by full VSOP87 theory.  Result is at equator and equinox
// // of date in the FK5 frame.  It does not include nutation or aberration.
// //
// //	s: ecliptic longitude
// //	β: ecliptic latitude
// //	R: range in AU
// func TrueVSOP87(e *pp.V87Planet, jde float64) (s, β unit.Angle, R float64) {
// 	l, b, r := e.Position(jde)
// 	s = l + math.Pi
// 	// FK5 correction.
// 	λp := base.Horner(base.J2000Century(jde),
// 		s.Rad(), -1.397*math.Pi/180, -.00031*math.Pi/180)
// 	sλp, cλp := math.Sincos(λp)
// 	Δβ := unit.Angle.fromSec(.03916).Mul(cλp - sλp)
// 	// (25.9) p. 166
// 	s -= unit.Angle.fromSec(.09033)
// 	return s.Mod1(), Δβ - b, r
// }

// // ApparentVSOP87 returns the apparent position of the sun as ecliptic coordinates.
// //
// // Result computed by VSOP87, at equator and equinox of date in the FK5 frame,
// // and includes effects of nutation and aberration.
// //
// //  λ: ecliptic longitude
// //  β: ecliptic latitude
// //  R: range in AU
// func ApparentVSOP87(e *pp.V87Planet, jde float64) (λ, β unit.Angle, R float64) {
// 	// note: see duplicated code in ApparentEquatorialVSOP87.
// 	s, β, R := TrueVSOP87(e, jde)
// 	Δψ, _ := nutation.Nutation(jde)
// 	a := aberration(R)
// 	return s + Δψ + a, β, R
// }

// // ApparentEquatorialVSOP87 returns the apparent position of the sun as equatorial coordinates.
// //
// // Result computed by VSOP87, at equator and equinox of date in the FK5 frame,
// // and includes effects of nutation and aberration.
// //
// //	α: right ascension
// //	δ: declination
// //	R: range in AU
// func ApparentEquatorialVSOP87(e *pp.V87Planet, jde float64) (α unit.RA, δ unit.Angle, R float64) {
// 	// note: duplicate code from ApparentVSOP87 so we can keep Δε.
// 	// see also duplicate code in time.E().
// 	s, β, R := TrueVSOP87(e, jde)
// 	Δψ, Δε := nutation.Nutation(jde)
// 	a := aberration(R)
// 	λ := s + Δψ + a
// 	ε := nutation.MeanObliquity(jde) + Δε
// 	sε, cε := ε.Sincos()
// 	α, δ = coord.EclToEq(λ, β, sε, cε)
// 	return
// }

// // Low precision formula.  The high precision formula is not implemented
// // because the low precision formula already gives position results to the
// // accuracy given on p. 165.  The high precision formula the represents lots
// // of typing with associated chance of typos, and no way to test the result.
// func aberration(R float64) unit.Angle {
// 	// (25.10) p. 167
// 	return unit.Angle.fromSec(-20.4898).Div(R)
// }
