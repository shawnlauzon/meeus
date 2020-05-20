// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

import 'dart:math' as math;
import 'package:unit/unit.dart' as unit;

import 'base.dart' as base;

class Position {
  /// Geocentric longitude.
  final unit.Angle lambda;

  /// Geocentric latidude.
  final unit.Angle beta;

  /// Distance between centers of the Earth and Moon, in km.
  final num delta;

  const Position(this.lambda, this.beta, this.delta);
}

/// Parallax returns equatorial horizontal parallax of the Moon.
///
/// Argument delta is distance between centers of the Earth and Moon, in km.
unit.Angle parallax(num delta) {
  // p. 337
  return unit.Angle(math.asin(6378.14 / delta));
}

const _p = math.pi / 180;

class _Dmf {
  final num d;
  final num m;
  final num mPrime;
  final num f;

  const _Dmf(this.d, this.m, this.mPrime, this.f);
}

_Dmf _dmf(num t) {
  final d = base.horner(t, [
    297.8501921 * _p,
    445267.1114034 * _p,
    -.0018819 * _p,
    _p / 545868,
    -_p / 113065000
  ]);
  final m = base.horner(
      t, [357.5291092 * _p, 35999.0502909 * _p, -.0001535 * _p, _p / 24490000]);
  final mPrime = base.horner(t, [
    134.9633964 * _p,
    477198.8675055 * _p,
    .0087414 * _p,
    _p / 69699,
    -_p / 14712000
  ]);
  final f = base.horner(t, [
    93.272095 * _p,
    483202.0175233 * _p,
    -.0036539 * _p,
    -_p / 3526000,
    _p / 863310000
  ]);
  return _Dmf(d, m, mPrime, f);
}

/// Position returns geocentric location of the Moon.
///
/// Results are referenced to mean equinox of date and do not include
/// the effect of nutation.
Position position(num jde) {
  var T = base.j2000Century(jde);
  var lPrime = base.horner(T, [
    218.3164477 * _p,
    481267.88123421 * _p,
    -.0015786 * _p,
    _p / 538841,
    -_p / 65194000
  ]);
  var dmf = _dmf(T);
  var D = dmf.d, M = dmf.m, mPrime = dmf.mPrime, F = dmf.f;
  var A1 = 119.75 * _p + 131.849 * _p * T;
  var A2 = 53.09 * _p + 479264.29 * _p * T;
  var A3 = 313.45 * _p + 481266.484 * _p * T;
  var E = base.horner(T, [1, -.002516, -.0000074]);
  var E2 = E * E;
  var sigmal =
      3958 * math.sin(A1) + 1962 * math.sin(lPrime - F) + 318 * math.sin(A2);
  var sigmar = 0.0;
  var sigmab = -2235 * math.sin(lPrime) +
      382 * math.sin(A3) +
      175 * math.sin(A1 - F) +
      175 * math.sin(A1 + F) +
      127 * math.sin(lPrime - mPrime) -
      115 * math.sin(lPrime + mPrime);
  for (var i = 0; i < _ta.length; i++) {
    var r = _ta[i];
    var sa = math.sin(D * r.d + M * r.m + mPrime * r.mPrime + F * r.f);
    var ca = math.cos(D * r.d + M * r.m + mPrime * r.mPrime + F * r.f);
    switch (r.m) {
      case 0:
        sigmal += r.sigmaL * sa;
        sigmar += r.sigmaR * ca;
        break;
      case 1:
      case -1:
        sigmal += r.sigmaL * sa * E;
        sigmar += r.sigmaR * ca * E;
        break;
      case 2:
      case -2:
        sigmal += r.sigmaL * sa * E2;
        sigmar += r.sigmaR * ca * E2;
        break;
    }
  }
  for (var i = 0; i < _tb.length; i++) {
    var r = _tb[i];
    var sb = math.sin(D * r.D + M * r.M + mPrime * r.mPrime + F * r.F);
    switch (r.M) {
      case 0:
        sigmab += r.sigmaB * sb;
        break;
      case 1:
      case -1:
        sigmab += r.sigmaB * sb * E;
        break;
      case 2:
      case -2:
        sigmab += r.sigmaB * sb * E2;
        break;
    }
  }
  final lambda = unit.Angle(lPrime).mod1() + unit.Angle.fromDeg(sigmal * 1e-6);
  final beta = unit.Angle.fromDeg(sigmab * 1e-6);
  final delta = 385000.56 + sigmar * 1e-3;
  return Position(lambda, beta, delta);
}

class _Tas {
  final num d;
  final num m;
  final num mPrime;
  final num f;
  final num sigmaL;
  final num sigmaR;

  const _Tas(this.d, this.m, this.mPrime, this.f, this.sigmaL, this.sigmaR);
}

const List<_Tas> _ta = [
  _Tas(0, 0, 1, 0, 6288774, -20905355),
  _Tas(2, 0, -1, 0, 1274027, -3699111),
  _Tas(2, 0, 0, 0, 658314, -2955968),
  _Tas(0, 0, 2, 0, 213618, -569925),
  _Tas(0, 1, 0, 0, -185116, 48888),
  _Tas(0, 0, 0, 2, -114332, -3149),
  _Tas(2, 0, -2, 0, 58793, 246158),
  _Tas(2, -1, -1, 0, 57066, -152138),
  _Tas(2, 0, 1, 0, 53322, -170733),
  _Tas(2, -1, 0, 0, 45758, -204586),
  _Tas(0, 1, -1, 0, -40923, -129620),
  _Tas(1, 0, 0, 0, -34720, 108743),
  _Tas(0, 1, 1, 0, -30383, 104755),
  _Tas(2, 0, 0, -2, 15327, 10321),
  _Tas(0, 0, 1, 2, -12528, 0),
  _Tas(0, 0, 1, -2, 10980, 79661),
  _Tas(4, 0, -1, 0, 10675, -34782),
  _Tas(0, 0, 3, 0, 10034, -23210),
  _Tas(4, 0, -2, 0, 8548, -21636),
  _Tas(2, 1, -1, 0, -7888, 24208),
  _Tas(2, 1, 0, 0, -6766, 30824),
  _Tas(1, 0, -1, 0, -5163, -8379),
  _Tas(1, 1, 0, 0, 4987, -16675),
  _Tas(2, -1, 1, 0, 4036, -12831),
  _Tas(2, 0, 2, 0, 3994, -10445),
  _Tas(4, 0, 0, 0, 3861, -11650),
  _Tas(2, 0, -3, 0, 3665, 14403),
  _Tas(0, 1, -2, 0, -2689, -7003),
  _Tas(2, 0, -1, 2, -2602, 0),
  _Tas(2, -1, -2, 0, 2390, 10056),
  _Tas(1, 0, 1, 0, -2348, 6322),
  _Tas(2, -2, 0, 0, 2236, -9884),
  _Tas(0, 1, 2, 0, -2120, 5751),
  _Tas(0, 2, 0, 0, -2069, 0),
  _Tas(2, -2, -1, 0, 2048, -4950),
  _Tas(2, 0, 1, -2, -1773, 4130),
  _Tas(2, 0, 0, 2, -1595, 0),
  _Tas(4, -1, -1, 0, 1215, -3958),
  _Tas(0, 0, 2, 2, -1110, 0),
  _Tas(3, 0, -1, 0, -892, 3258),
  _Tas(2, 1, 1, 0, -810, 2616),
  _Tas(4, -1, -2, 0, 759, -1897),
  _Tas(0, 2, -1, 0, -713, -2117),
  _Tas(2, 2, -1, 0, -700, 2354),
  _Tas(2, 1, -2, 0, 691, 0),
  _Tas(2, -1, 0, -2, 596, 0),
  _Tas(4, 0, 1, 0, 549, -1423),
  _Tas(0, 0, 4, 0, 537, -1117),
  _Tas(4, -1, 0, 0, 520, -1571),
  _Tas(1, 0, -2, 0, -487, -1739),
  _Tas(2, 1, 0, -2, -399, 0),
  _Tas(0, 0, 2, -2, -381, -4421),
  _Tas(1, 1, 1, 0, 351, 0),
  _Tas(3, 0, -2, 0, -340, 0),
  _Tas(4, 0, -3, 0, 330, 0),
  _Tas(2, -1, 2, 0, 327, 0),
  _Tas(0, 2, 1, 0, -323, 1165),
  _Tas(1, 1, -1, 0, 299, 0),
  _Tas(2, 0, 3, 0, 294, 0),
  _Tas(2, 0, -1, -2, 0, 8752),
];

class _Tbs {
  final num D;
  final num M;
  final num mPrime;
  final num F;
  final num sigmaB;

  const _Tbs(this.D, this.M, this.mPrime, this.F, this.sigmaB);
}

const List<_Tbs> _tb = [
  _Tbs(0, 0, 0, 1, 5128122),
  _Tbs(0, 0, 1, 1, 280602),
  _Tbs(0, 0, 1, -1, 277693),
  _Tbs(2, 0, 0, -1, 173237),
  _Tbs(2, 0, -1, 1, 55413),
  _Tbs(2, 0, -1, -1, 46271),
  _Tbs(2, 0, 0, 1, 32573),
  _Tbs(0, 0, 2, 1, 17198),
  _Tbs(2, 0, 1, -1, 9266),
  _Tbs(0, 0, 2, -1, 8822),
  _Tbs(2, -1, 0, -1, 8216),
  _Tbs(2, 0, -2, -1, 4324),
  _Tbs(2, 0, 1, 1, 4200),
  _Tbs(2, 1, 0, -1, -3359),
  _Tbs(2, -1, -1, 1, 2463),
  _Tbs(2, -1, 0, 1, 2211),
  _Tbs(2, -1, -1, -1, 2065),
  _Tbs(0, 1, -1, -1, -1870),
  _Tbs(4, 0, -1, -1, 1828),
  _Tbs(0, 1, 0, 1, -1794),
  _Tbs(0, 0, 0, 3, -1749),
  _Tbs(0, 1, -1, 1, -1565),
  _Tbs(1, 0, 0, 1, -1491),
  _Tbs(0, 1, 1, 1, -1475),
  _Tbs(0, 1, 1, -1, -1410),
  _Tbs(0, 1, 0, -1, -1344),
  _Tbs(1, 0, 0, -1, -1335),
  _Tbs(0, 0, 3, 1, 1107),
  _Tbs(4, 0, 0, -1, 1021),
  _Tbs(4, 0, -1, 1, 833),
  _Tbs(0, 0, 1, -3, 777),
  _Tbs(4, 0, -2, 1, 671),
  _Tbs(2, 0, 0, -3, 607),
  _Tbs(2, 0, 2, -1, 596),
  _Tbs(2, -1, 1, -1, 491),
  _Tbs(2, 0, -2, 1, -451),
  _Tbs(0, 0, 3, -1, 439),
  _Tbs(2, 0, 2, 1, 422),
  _Tbs(2, 0, -3, -1, 421),
  _Tbs(2, 1, -1, 1, -366),
  _Tbs(2, 1, 0, 1, -351),
  _Tbs(4, 0, 0, 1, 331),
  _Tbs(2, -1, 1, 1, 315),
  _Tbs(2, -2, 0, -1, 302),
  _Tbs(0, 0, 1, 3, -283),
  _Tbs(2, 1, 1, -1, -229),
  _Tbs(1, 1, 0, -1, 223),
  _Tbs(1, 1, 0, 1, 223),
  _Tbs(0, 1, -2, -1, -220),
  _Tbs(2, 1, -1, -1, -220),
  _Tbs(1, 0, 1, 1, -185),
  _Tbs(2, -1, -2, -1, 181),
  _Tbs(0, 1, 2, 1, -177),
  _Tbs(4, 0, -2, -1, 176),
  _Tbs(4, -1, -1, -1, 166),
  _Tbs(1, 0, 1, -1, -164),
  _Tbs(4, 0, 1, -1, 132),
  _Tbs(1, 0, -1, -1, -119),
  _Tbs(4, -1, 0, -1, 115),
  _Tbs(2, -2, 0, 1, 107),
];
