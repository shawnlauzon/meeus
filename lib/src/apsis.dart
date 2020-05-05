/// Copyright 2020 Shawn Lauzon
/// Copyright 2013 Sonia Keys
/// License: MIT

/// Apsis: Chapter 50, Perigee and apogee of the Moon
library apsis;

import 'dart:math' as math;

import 'package:unit/unit.dart' as unit;

import 'base.dart' as base;

/// conversion factor from k to T, given in (50.3) p. 356
const _ck = 1 / 1325.55;

/// (50.1) p. 355
num _mean(num T) {
  return base.horner(T,
      [2451534.6698, 27.55454989 / _ck, -.0006691, -.000001098, .0000000052]);
}

/// Returns k at half h nearest year y.
num _snap(num y, num h) {
  final k = (y - 1999.97) * 13.2555; // (50.2) p. 355
  return (k - h + .5).floor() + h;
}

/// Returns the jde of the mean perigee of the Moon nearest the given date.
//
/// Year is a decimal year specifying a date.
num meanPerigee(num year) {
  return _mean(_snap(year, 0) * _ck);
}

/// Returns the jde of perigee of the Moon nearest the given date.
//
/// Year is a decimal year specifying a date.
num perigee(num year) {
  final la = _La(year, 0);
  return _mean(la.T) + la.pc();
}

/// Returns the jde of the mean apogee of the Moon nearest the given date.
//
/// Year is a decimal year specifying a date.
num meanApogee(num year) {
  return _mean(_snap(year, .5) * _ck);
}

/// Returns the jde of apogee of the Moon nearest the given date.
//
/// Year is a decimal year specifying a date.
num apogee(num year) {
  final la = _La(year, .5);
  return _mean(la.T) + la.ac();
}

/// Returns equatorial horizontal parallax of the Moon at the Apogee nearest the given date.
//
/// Year is a decimal year specifying a date.
unit.Angle apogeeParallax(num year) {
  return _La(year, .5).ap();
}

/// Returns equatorial horizontal parallax of the Moon at the Perigee nearest the given date.
//
/// Year is a decimal year specifying a date.
unit.Angle perigeeParallax(num year) {
  return _La(year, 0).pp();
}

class _La {
  static const _p = math.pi / 180;

  final num k;
  final num T;
  final num D;
  final num M;
  final num F;

  _La(num y, num h)
      : this._fromKT(_snap(y, h), _snap(y, h) * _ck); // (50.3) p. 350

  _La._fromKT(this.k, this.T)
      : D = base.horner(T, [
          171.9179 * _p,
          335.9106046 * _p / _ck,
          -.0100383 * _p,
          -.00001156 * _p,
          .000000055 * _p
        ]),
        M = base.horner(T, [
          347.3477 * _p,
          27.1577721 * _p / _ck,
          -.000813 * _p,
          -.000001 * _p
        ]),
        F = base.horner(T, [
          316.6109 * _p,
          364.5287911 * _p / _ck,
          -.0125053 * _p,
          -.0000148 * _p
        ]);

  /// perigee correction
  num pc() {
    return -1.6769 * math.sin(2 * D) +
        .4589 * math.sin(4 * D) +
        -.1856 * math.sin(6 * D) +
        .0883 * math.sin(8 * D) +
        (-.0773 + .00019 * T) * math.sin(2 * D - M) +
        (.0502 - .00013 * T) * math.sin(M) +
        -.046 * math.sin(10 * D) +
        (.0422 - .00011 * T) * math.sin(4 * D - M) +
        -.0256 * math.sin(6 * D - M) +
        .0253 * math.sin(12 * D) +
        .0237 * math.sin(D) +
        .0162 * math.sin(8 * D - M) +
        -.0145 * math.sin(14 * D) +
        .0129 * math.sin(2 * F) +
        -.0112 * math.sin(3 * D) +
        -.0104 * math.sin(10 * D - M) +
        .0086 * math.sin(16 * D) +
        .0069 * math.sin(12 * D - M) +
        .0066 * math.sin(5 * D) +
        -.0053 * math.sin(2 * (D + F)) +
        -.0052 * math.sin(18 * D) +
        -.0046 * math.sin(14 * D - M) +
        -.0041 * math.sin(7 * D) +
        .004 * math.sin(2 * D + M) +
        .0032 * math.sin(20 * D) +
        -.0032 * math.sin(D + M) +
        .0031 * math.sin(16 * D - M) +
        -.0029 * math.sin(4 * D + M) +
        .0027 * math.sin(9 * D) +
        .0027 * math.sin(4 * D + 2 * F) +
        -.0027 * math.sin(2 * (D - M)) +
        .0024 * math.sin(4 * D - 2 * M) +
        -.0021 * math.sin(6 * D - 2 * M) +
        -.0021 * math.sin(22 * D) +
        -.0021 * math.sin(18 * D - M) +
        .0019 * math.sin(6 * D + M) +
        -.0018 * math.sin(11 * D) +
        -.0014 * math.sin(8 * D + M) +
        -.0014 * math.sin(4 * D - 2 * F) +
        -.0014 * math.sin(6 * D + 2 * F) +
        .0014 * math.sin(3 * D + M) +
        -.0014 * math.sin(5 * D + M) +
        .0013 * math.sin(13 * D) +
        .0013 * math.sin(20 * D - M) +
        .0011 * math.sin(3 * D + 2 * M) +
        -.0011 * math.sin(2 * (2 * D + F - M)) +
        -.001 * math.sin(D + 2 * M) +
        -.0009 * math.sin(22 * D - M) +
        -.0008 * math.sin(4 * F) +
        .0008 * math.sin(6 * D - 2 * F) +
        .0008 * math.sin(2 * (D - F) + M) +
        .0007 * math.sin(2 * M) +
        .0007 * math.sin(2 * F - M) +
        .0007 * math.sin(2 * D + 4 * F) +
        -.0006 * math.sin(2 * (F - M)) +
        -.0006 * math.sin(2 * (D - F + M)) +
        .0006 * math.sin(24 * D) +
        .0005 * math.sin(4 * (D - F)) +
        .0005 * math.sin(2 * (D + M)) +
        -.0004 * math.sin(D - M);
  }

  /// apogee correction
  num ac() {
    return .4392 * math.sin(2 * D) +
        .0684 * math.sin(4 * D) +
        (.0456 - .00011 * T) * math.sin(M) +
        (.0426 - .00011 * T) * math.sin(2 * D - M) +
        .0212 * math.sin(2 * F) +
        -.0189 * math.sin(D) +
        .0144 * math.sin(6 * D) +
        .0113 * math.sin(4 * D - M) +
        .0047 * math.sin(2 * (D + F)) +
        .0036 * math.sin(D + M) +
        .0035 * math.sin(8 * D) +
        .0034 * math.sin(6 * D - M) +
        -.0034 * math.sin(2 * (D - F)) +
        .0022 * math.sin(2 * (D - M)) +
        -.0017 * math.sin(3 * D) +
        .0013 * math.sin(4 * D + 2 * F) +
        .0011 * math.sin(8 * D - M) +
        .001 * math.sin(4 * D - 2 * M) +
        .0009 * math.sin(10 * D) +
        .0007 * math.sin(3 * D + M) +
        .0006 * math.sin(2 * M) +
        .0005 * math.sin(2 * D + M) +
        .0005 * math.sin(2 * (D + M)) +
        .0004 * math.sin(6 * D + 2 * F) +
        .0004 * math.sin(6 * D - 2 * M) +
        .0004 * math.sin(10 * D - M) +
        -.0004 * math.sin(5 * D) +
        -.0004 * math.sin(4 * D - 2 * F) +
        .0003 * math.sin(2 * F + M) +
        .0003 * math.sin(12 * D) +
        .0003 * math.sin(2 * D + 2 * F - M) +
        -.0003 * math.sin(D - M);
  }

  /// apogee parallax
  unit.Angle ap() {
    return unit.Angle.fromSec(3245.251 +
        -9.147 * math.cos(2 * D) +
        -.841 * math.cos(D) +
        .697 * math.cos(2 * F) +
        (-.656 + .0016 * T) * math.cos(M) +
        .355 * math.cos(4 * D) +
        .159 * math.cos(2 * D - M) +
        .127 * math.cos(D + M) +
        .065 * math.cos(4 * D - M) +
        .052 * math.cos(6 * D) +
        .043 * math.cos(2 * D + M) +
        .031 * math.cos(2 * (D + F)) +
        -.023 * math.cos(2 * (D - F)) +
        .022 * math.cos(2 * (D - M)) +
        .019 * math.cos(2 * (D + M)) +
        -.016 * math.cos(2 * M) +
        .014 * math.cos(6 * D - M) +
        .01 * math.cos(8 * D));
  }

  /// perigee parallax
  unit.Angle pp() {
    return unit.Angle.fromSec(3629.215 +
        63.224 * math.cos(2 * D) +
        -6.990 * math.cos(4 * D) +
        (2.834 - 0.0071 * T) * math.cos(2 * D - M) +
        1.927 * math.cos(6 * D) +
        -1.263 * math.cos(D) +
        -0.702 * math.cos(8 * D) +
        (0.696 - 0.0017 * T) * math.cos(M) +
        -0.690 * math.cos(2 * F) +
        (-0.629 + 0.0016 * T) * math.cos(4 * D - M) +
        -0.392 * math.cos(2 * (D - F)) +
        0.297 * math.cos(10 * D) +
        0.260 * math.cos(6 * D - M) +
        0.201 * math.cos(3 * D) +
        -0.161 * math.cos(2 * D + M) +
        0.157 * math.cos(D + M) +
        -0.138 * math.cos(12 * D) +
        -0.127 * math.cos(8 * D - M) +
        0.104 * math.cos(2 * (D + F)) +
        0.104 * math.cos(2 * (D - M)) +
        -0.079 * math.cos(5 * D) +
        0.068 * math.cos(14 * D) +
        0.067 * math.cos(10 * D - M) +
        0.054 * math.cos(4 * D + M) +
        -0.038 * math.cos(12 * D - M) +
        -0.038 * math.cos(4 * D - 2 * M) +
        0.037 * math.cos(7 * D) +
        -0.037 * math.cos(4 * D + 2 * F) +
        -0.035 * math.cos(16 * D) +
        -0.030 * math.cos(3 * D + M) +
        0.029 * math.cos(D - M) +
        -0.025 * math.cos(6 * D + M) +
        0.023 * math.cos(2 * M) +
        0.023 * math.cos(14 * D - M) +
        -0.023 * math.cos(2 * (D + M)) +
        0.022 * math.cos(6 * D - 2 * M) +
        -0.021 * math.cos(2 * D - 2 * F - M) +
        -0.020 * math.cos(9 * D) +
        0.019 * math.cos(18 * D) +
        0.017 * math.cos(6 * D + 2 * F) +
        0.014 * math.cos(2 * F - M) +
        -0.014 * math.cos(16 * D - M) +
        0.013 * math.cos(4 * D - 2 * F) +
        0.012 * math.cos(8 * D + M) +
        0.011 * math.cos(11 * D) +
        0.010 * math.cos(5 * D + M) +
        -0.010 * math.cos(20 * D));
  }
}
