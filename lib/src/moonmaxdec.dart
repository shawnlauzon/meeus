// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

// Moonmaxdec: Chapter 52, Maximum Declinations of the Moon

import 'dart:math' as math;

import 'package:unit/unit.dart' as unit;

import 'base.dart' as base;

/// Computes the maximum northern declination of the Moon near a given date.
///
/// Argument [year] is a decimal year specifying a date near the event.
Declination north(num year) {
  return _max(year, _nc);
}

class Declination {
  /// Julian date of the event nearest the given date
  final num jde;

  /// Declination of the Moon at that time
  final unit.Angle delta;

  const Declination(this.jde, this.delta);
}

/// South computes the maximum southern declination of the Moon near a given date.
///
/// Argument [year] is a decimal year specifying a date near the event.
Declination south(num year) {
  return _max(year, _sc);
}

const _p = math.pi / 180;

Declination _max(num y, _Mc c) {
  var k = (y - 2000.03) * 13.3686; // (52.1) p. 367
  k = (k + .5).floor() as double;
  const ck = 1 / 1336.86;
  final T = k * ck;
  final D = base
      .horner(T, [c.D, 333.0705546 * _p / ck, -.0004214 * _p, .00000011 * _p]);
  final M = base
      .horner(T, [c.M, 26.9281592 * _p / ck, -.0000355 * _p, -.0000001 * _p]);
  final M_ = base
      .horner(T, [c.M_, 356.9562794 * _p / ck, .0103066 * _p, .00001251 * _p]);
  final F = base
      .horner(T, [c.F, 1.4467807 * _p / ck, -.002069 * _p, -.00000215 * _p]);
  final E = base.horner(T, [1, -.002516, -.0000074]);
  final jde =
      base.horner(T, [c.JDE, 27.321582247 / ck, .000119804, -.000000141]) +
          c.tc[0] * math.cos(F) +
          c.tc[1] * math.sin(M_) +
          c.tc[2] * math.sin(2 * F) +
          c.tc[3] * math.sin(2 * D - M_) +
          c.tc[4] * math.cos(M_ - F) +
          c.tc[5] * math.cos(M_ + F) +
          c.tc[6] * math.sin(2 * D) +
          c.tc[7] * math.sin(M) * E +
          c.tc[8] * math.cos(3 * F) +
          c.tc[9] * math.sin(M_ + 2 * F) +
          c.tc[10] * math.cos(2 * D - F) +
          c.tc[11] * math.cos(2 * D - M_ - F) +
          c.tc[12] * math.cos(2 * D - M_ + F) +
          c.tc[13] * math.cos(2 * D + F) +
          c.tc[14] * math.sin(2 * M_) +
          c.tc[15] * math.sin(M_ - 2 * F) +
          c.tc[16] * math.cos(2 * M_ - F) +
          c.tc[17] * math.sin(M_ + 3 * F) +
          c.tc[18] * math.sin(2 * D - M - M_) * E +
          c.tc[19] * math.cos(M_ - 2 * F) +
          c.tc[20] * math.sin(2 * (D - M_)) +
          c.tc[21] * math.sin(F) +
          c.tc[22] * math.sin(2 * D + M_) +
          c.tc[23] * math.cos(M_ + 2 * F) +
          c.tc[24] * math.sin(2 * D - M) * E +
          c.tc[25] * math.sin(M_ + F) +
          c.tc[26] * math.sin(M - M_) * E +
          c.tc[27] * math.sin(M_ - 3 * F) +
          c.tc[28] * math.sin(2 * M_ + F) +
          c.tc[29] * math.cos(2 * (D - M_) - F) +
          c.tc[30] * math.sin(3 * F) +
          c.tc[31] * math.cos(M_ + 3 * F) +
          c.tc[32] * math.cos(2 * M_) +
          c.tc[33] * math.cos(2 * D - M_) +
          c.tc[34] * math.cos(2 * D + M_ + F) +
          c.tc[35] * math.cos(M_) +
          c.tc[36] * math.sin(3 * M_ + F) +
          c.tc[37] * math.sin(2 * D - M_ + F) +
          c.tc[38] * math.cos(2 * (D - M_)) +
          c.tc[39] * math.cos(D + F) +
          c.tc[40] * math.sin(M + M_) * E +
          c.tc[41] * math.sin(2 * (D - F)) +
          c.tc[42] * math.cos(2 * M_ + F) +
          c.tc[43] * math.cos(3 * M_ + F);
  final de = unit.Angle(23.6961 * _p -
      .013004 * _p * T +
      c.dc[0] * math.sin(F) +
      c.dc[1] * math.cos(2 * F) +
      c.dc[2] * math.sin(2 * D - F) +
      c.dc[3] * math.sin(3 * F) +
      c.dc[4] * math.cos(2 * (D - F)) +
      c.dc[5] * math.cos(2 * D) +
      c.dc[6] * math.sin(M_ - F) +
      c.dc[7] * math.sin(M_ + 2 * F) +
      c.dc[8] * math.cos(F) +
      c.dc[9] * math.sin(2 * D + M - F) * E +
      c.dc[10] * math.sin(M_ + 3 * F) +
      c.dc[11] * math.sin(D + F) +
      c.dc[12] * math.sin(M_ - 2 * F) +
      c.dc[13] * math.sin(2 * D - M - F) * E +
      c.dc[14] * math.sin(2 * D - M_ - F) +
      c.dc[15] * math.cos(M_ + F) +
      c.dc[16] * math.cos(M_ + 2 * F) +
      c.dc[17] * math.cos(2 * M_ + F) +
      c.dc[18] * math.cos(M_ - 3 * F) +
      c.dc[19] * math.cos(2 * M_ - F) +
      c.dc[20] * math.cos(M_ - 2 * F) +
      c.dc[21] * math.sin(2 * M_) +
      c.dc[22] * math.sin(3 * M_ + F) +
      c.dc[23] * math.cos(2 * D + M - F) * E +
      c.dc[24] * math.cos(M_ - F) +
      c.dc[25] * math.cos(3 * F) +
      c.dc[26] * math.sin(2 * D + F) +
      c.dc[27] * math.cos(M_ + 3 * F) +
      c.dc[28] * math.cos(D + F) +
      c.dc[29] * math.sin(2 * M_ - F) +
      c.dc[30] * math.cos(3 * M_ + F) +
      c.dc[31] * math.cos(2 * (D + M_) + F) +
      c.dc[32] * math.sin(2 * (D - M_) - F) +
      c.dc[33] * math.cos(2 * M_) +
      c.dc[34] * math.cos(M_) +
      c.dc[35] * math.sin(2 * F) +
      c.dc[36] * math.sin(M_ + F));
  return Declination(jde, de.mul(c.s));
}

class _Mc {
  final num D;
  final num M;
  final num M_;
  final num F;
  final num JDE;
  final num s;
  final List<num> tc;
  final List<num> dc;

  const _Mc(
      {required this.D,
      required this.M,
      required this.M_,
      required this.F,
      required this.JDE,
      required this.s,
      required this.tc,
      required this.dc});
}

// north coefficients
const _nc = _Mc(
    D: 152.2029 * _p,
    M: 14.8591 * _p,
    M_: 4.6881 * _p,
    F: 325.8867 * _p,
    JDE: 2451562.5897,
    s: 1,
    tc: [
      .8975,
      -.4726,
      -.1030,
      -.0976,
      -.0462,
      -.0461,
      -.0438,
      .0162,
      -.0157,
      .0145,
      .0136,
      -.0095,
      -.0091,
      -.0089,
      .0075,
      -.0068,
      .0061,
      -.0047,
      -.0043,
      -.004,
      -.0037,
      .0031,
      .0030,
      -.0029,
      -.0029,
      -.0027,
      .0024,
      -.0021,
      .0019,
      .0018,
      .0018,
      .0017,
      .0017,
      -.0014,
      .0013,
      .0013,
      .0012,
      .0011,
      -.0011,
      .001,
      .001,
      -.0009,
      .0007,
      -.0007,
    ],
    dc: [
      5.1093 * _p,
      .2658 * _p,
      .1448 * _p,
      -.0322 * _p,
      .0133 * _p,
      .0125 * _p,
      -.0124 * _p,
      -.0101 * _p,
      .0097 * _p,
      -.0087 * _p,
      .0074 * _p,
      .0067 * _p,
      .0063 * _p,
      .0060 * _p,
      -.0057 * _p,
      -.0056 * _p,
      .0052 * _p,
      .0041 * _p,
      -.004 * _p,
      .0038 * _p,
      -.0034 * _p,
      -.0029 * _p,
      .0029 * _p,
      -.0028 * _p,
      -.0028 * _p,
      -.0023 * _p,
      -.0021 * _p,
      .0019 * _p,
      .0018 * _p,
      .0017 * _p,
      .0015 * _p,
      .0014 * _p,
      -.0012 * _p,
      -.0012 * _p,
      -.001 * _p,
      -.001 * _p,
      .0006 * _p,
    ]);

// south coefficients
var _sc = _Mc(
    D: 345.6676 * _p,
    M: 1.3951 * _p,
    M_: 186.21 * _p,
    F: 145.1633 * _p,
    JDE: 2451548.9289,
    s: -1,
    tc: [
      -.8975,
      -.4726,
      -.1030,
      -.0976,
      .0541,
      .0516,
      -.0438,
      .0112,
      .0157,
      .0023,
      -.0136,
      .011,
      .0091,
      .0089,
      .0075,
      -.003,
      -.0061,
      -.0047,
      -.0043,
      .004,
      -.0037,
      -.0031,
      .0030,
      .0029,
      -.0029,
      -.0027,
      .0024,
      -.0021,
      -.0019,
      -.0006,
      -.0018,
      -.0017,
      .0017,
      .0014,
      -.0013,
      -.0013,
      .0012,
      .0011,
      .0011,
      .001,
      .001,
      -.0009,
      -.0007,
      -.0007,
    ],
    dc: [
      -5.1093 * _p,
      .2658 * _p,
      -.1448 * _p,
      .0322 * _p,
      .0133 * _p,
      .0125 * _p,
      -.0015 * _p,
      .0101 * _p,
      -.0097 * _p,
      .0087 * _p,
      .0074 * _p,
      .0067 * _p,
      -.0063 * _p,
      -.0060 * _p,
      .0057 * _p,
      -.0056 * _p,
      -.0052 * _p,
      -.0041 * _p,
      -.004 * _p,
      -.0038 * _p,
      .0034 * _p,
      -.0029 * _p,
      .0029 * _p,
      .0028 * _p,
      -.0028 * _p,
      .0023 * _p,
      .0021 * _p,
      .0019 * _p,
      .0018 * _p,
      -.0017 * _p,
      .0015 * _p,
      .0014 * _p,
      .0012 * _p,
      -.0012 * _p,
      .001 * _p,
      -.001 * _p,
      .0037 * _p,
    ]);
