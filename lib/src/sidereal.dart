// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

// Sidereal: Chapter 12, Sidereal Time at Greenwich.

import 'package:unit/unit.dart' as unit;

import 'base.dart' as base;
import 'nutation.dart' as nutation;

/// Returns values for use in computing sidereal time at Greenwich.
_CFrac _jdToCFrac(num jd) {
  final result = base.modf(jd + .5);

  return _CFrac(base.j2000Century(result.intPart - .5), result.fracPart);
}

class _CFrac {
  /// Cen is centuries from J2000 of the JD at 0h UT of argument [jd].  This is
  /// the value to use for evaluating the IAU sidereal time polynomial.
  final num cen;

  /// DayFrac is the fraction of jd after 0h UT.  It is used to compute the
  /// final value of sidereal time.
  final num dayFrac;

  const _CFrac(this.cen, this.dayFrac);
}

/// A polynomial giving mean sidereal time at Greenwich at 0h UT.
///
/// The polynomial is in centuries from J2000.0, as given by JDToCFrac.
/// Coefficients are those adopted in 1982 by the International Astronomical
/// Union and are given in (12.2) p. 87.
const _iau82 = [24110.54841, 8640184.812866, 0.093104, 0.0000062];

/// Returns mean sidereal time at Greenwich for a given JD.
///
/// Computation is by IAU 1982 coefficients.
/// The result is in the range [0,86400).
unit.Time mean(num jd) {
  return _mean(jd).mod1();
}

unit.Time _mean(num jd) {
  final sf = _mean0UT(jd);
  return sf.sidereal + sf.dayFrac * 1.00273790935;
}

/// Returns mean sidereal time at Greenwich at 0h UT on the given JD.
///
/// The result is in the range [0,86400).
unit.Time mean0UT(num jd) {
  final sd = _mean0UT(jd);
  return sd.sidereal.mod1();
}

_Mean0UT _mean0UT(num jd) {
  final cenDayfrac = _jdToCFrac(jd);

  /// (12.2) p. 87
  return _Mean0UT(unit.Time(base.horner(cenDayfrac.cen, _iau82)),
      unit.Time.fromDay(cenDayfrac.dayFrac));
}

class _Mean0UT {
  final unit.Time sidereal;
  final unit.Time dayFrac;

  const _Mean0UT(this.sidereal, this.dayFrac);
}

/// Returns apparent sidereal time at Greenwich for the given JD.
///
/// Apparent is mean plus the nutation in right ascension.
///
/// The result is in the range [0,86400).
unit.Time apparent(num jd) {
  final s = _mean(jd);

  /// Time
  final n = nutation.nutationInRA(jd);

  /// HourAngle
  return (s + n.time()).mod1();
}

/// Returns apparent sidereal time at Greenwich at 0h UT
/// on the given JD.
///
/// The result is in the range [0,86400).
unit.Time apparent0UT(num jd) {
  final j0f = base.modf(jd + .5);
  final cen = (j0f.intPart - .5 - base.j2000) / 36525;
  final s = unit.Time(base.horner(cen, _iau82)) +
      unit.Time.fromDay(j0f.fracPart * 1.00273790935);
  final n = nutation.nutationInRA(j0f.intPart);

  /// HourAngle
  return (s + n.time()).mod1();
}
