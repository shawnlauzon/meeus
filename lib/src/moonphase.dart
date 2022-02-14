// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

// Moonphase: Chapter 49, Phases of the Moon

import 'dart:math' as math;

import 'base.dart' as base;

const _ck = 1 / 1236.85;

/// (49.1) p. 349
num _mean(num T) {
  return base.horner(T,
      [2451550.09766, 29.530588861 / _ck, .00015437, -.00000015, .00000000073]);
}

/// Returns k at specified quarter q nearest year y.
num _snap(num y, num q) {
  final k = (y - 2000) * 12.3685;

  /// (49.2)  p. 350
  return (k - q + .5).floor() + q;
  // return (k - q + .5).ceil() + q;
}

/// Returns the jde of the mean New Moon nearest the given date.
///
/// [Year] is a decimal year specifying a date.
///
/// The mean date is within .5 day of the true date of New Moon.
num meanNewMoon(num year) {
  return _mean(_snap(year, 0) * _ck);
}

/// MeanFirst returns the jde of the mean First Quarter Moon nearest the given date.
///
/// Year is a decimal year specifying a date.
///
/// The mean date is within .5 day of the true date of First Quarter Moon.
num meanFirst(num year) {
  return _mean(_snap(year, .25) * _ck);
}

/// Returns the jde of the mean Full Moon nearest the given date.
///
/// [Year] is a decimal year specifying a date.
///
/// The mean date is within .5 day of the true date of New Moon.
num meanFull(num year) {
  return _mean(_snap(year, .5) * _ck);
}

/// Returns the jde of the mean Last Quarter Moon nearest the given date.
///
/// [Year] is a decimal year specifying a date.
///
/// The mean date is within .5 day of the true date of Last Quarter Moon.
num meanLast(num year) {
  return _mean(_snap(year, .75) * _ck);
}

/// Returns the jde of New Moon nearest the given date.
///
/// [Year] is a decimal year specifying a date.
num newMoon(num year) {
  final m = _newMp(year, .0);
  return _mean(m.T) + m._nfc(_nc) + m._a();
}

/// Returns the jde of First Quarter Moon nearest the given date.
///
/// [Year] is a decimal year specifying a date.
num first(num year) {
  final m = _newMp(year, .25);
  return _mean(m.T) + m._flc() + m._w() + m._a();
}

/// Returns the jde of Full Moon nearest the given date.
///
/// [Year] is a decimal year specifying a dat
num full(num year) {
  final m = _newMp(year, .5);
  return _mean(m.T) + m._nfc(_fc) + m._a();
}

/// Returns the jde of Last Quarter Moon nearest the given date.
///
/// [Year] is a decimal year specifying a date.
num last(num year) {
  final m = _newMp(year, .75);
  return _mean(m.T) + m._flc() - m._w() + m._a();
}

class _MoonPhase {
  late num k, T;
  late num E, M, MPrime, F, omega;
  List<num> A = List.filled(14, 0);

  _MoonPhase({required this.k});

  /// new or full corrections
  num _nfc(List<num> c) {
    return c[0] * math.sin(MPrime) +
        c[1] * math.sin(M) * E +
        c[2] * math.sin(2 * MPrime) +
        c[3] * math.sin(2 * F) +
        c[4] * math.sin(MPrime - M) * E +
        c[5] * math.sin(MPrime + M) * E +
        c[6] * math.sin(2 * M) * E * E +
        c[7] * math.sin(MPrime - 2 * F) +
        c[8] * math.sin(MPrime + 2 * F) +
        c[9] * math.sin(2 * MPrime + M) * E +
        c[10] * math.sin(3 * MPrime) +
        c[11] * math.sin(M + 2 * F) * E +
        c[12] * math.sin(M - 2 * F) * E +
        c[13] * math.sin(2 * MPrime - M) * E +
        c[14] * math.sin(omega) +
        c[15] * math.sin(MPrime + 2 * M) +
        c[16] * math.sin(2 * (MPrime - F)) +
        c[17] * math.sin(3 * M) +
        c[18] * math.sin(MPrime + M - 2 * F) +
        c[19] * math.sin(2 * (MPrime + F)) +
        c[20] * math.sin(MPrime + M + 2 * F) +
        c[21] * math.sin(MPrime - M + 2 * F) +
        c[22] * math.sin(MPrime - M - 2 * F) +
        c[23] * math.sin(3 * MPrime + M) +
        c[24] * math.sin(4 * MPrime);
  }

  /// first or last corrections
  num _flc() {
    return -.62801 * math.sin(MPrime) +
        .17172 * math.sin(M) * E +
        -.01183 * math.sin(MPrime + M) * E +
        .00862 * math.sin(2 * MPrime) +
        .00804 * math.sin(2 * F) +
        .00454 * math.sin(MPrime - M) * E +
        .00204 * math.sin(2 * M) * E * E +
        -.0018 * math.sin(MPrime - 2 * F) +
        -.0007 * math.sin(MPrime + 2 * F) +
        -.0004 * math.sin(3 * MPrime) +
        -.00034 * math.sin(2 * MPrime - M) +
        .00032 * math.sin(M + 2 * F) * E +
        .00032 * math.sin(M - 2 * F) * E +
        -.00028 * math.sin(MPrime + 2 * M) * E * E +
        .00027 * math.sin(2 * MPrime + M) * E +
        -.00017 * math.sin(omega) +
        -.00005 * math.sin(MPrime - M - 2 * F) +
        .00004 * math.sin(2 * MPrime + 2 * F) +
        -.00004 * math.sin(MPrime + M + 2 * F) +
        .00004 * math.sin(MPrime - 2 * M) +
        .00003 * math.sin(MPrime + M - 2 * F) +
        .00003 * math.sin(3 * M) +
        .00002 * math.sin(2 * MPrime - 2 * F) +
        .00002 * math.sin(MPrime - M + 2 * F) +
        -.00002 * math.sin(3 * MPrime + M);
  }

  num _w() {
    return .00306 -
        .00038 * E * math.cos(M) +
        .00026 * math.cos(MPrime) -
        .00002 *
            (math.cos(MPrime - M) - math.cos(MPrime + M) - math.cos(2 * F));
  }

  /// additional corrections
  num _a() {
    var a = .0;
    for (var i = 0; i < _ac.length; i++) {
      a += _ac[i] * math.sin(A[i]);
    }
    return a;
  }

  static const _ac = [
    .000325,
    .000165,
    .000164,
    .000126,
    .00011,
    .000062,
    .00006,
    .000056,
    .000047,
    .000042,
    .000040,
    .000037,
    .000035,
    .000023,
  ];
}

const _p = math.pi / 180;

_MoonPhase _newMp(num y, num q) {
  var m = _MoonPhase(k: _snap(y, q));
  m.T = m.k * _ck;

  /// (49.3)  p. 350
  m.E = base.horner(m.T, [1, -.002516, -.0000074]);
  m.M = base.horner(m.T,
      [2.5534 * _p, 29.1053567 * _p / _ck, -.0000014 * _p, -.00000011 * _p]);
  m.MPrime = base.horner(m.T, [
    201.5643 * _p,
    385.81693528 * _p / _ck,
    .0107582 * _p,
    .00001238 * _p,
    -.000000058 * _p
  ]);
  m.F = base.horner(m.T, [
    160.7108 * _p,
    390.67050284 * _p / _ck,
    -.0016118 * _p,
    -.00000227 * _p,
    .000000011 * _p
  ]);
  m.omega = base.horner(m.T,
      [124.7746 * _p, -1.56375588 * _p / _ck, .0020672 * _p, .00000215 * _p]);
  m.A[0] = 299.7 * _p + .107408 * _p * m.k - .009173 * m.T * m.T;
  m.A[1] = 251.88 * _p + .016321 * _p * m.k;
  m.A[2] = 251.83 * _p + 26.651886 * _p * m.k;
  m.A[3] = 349.42 * _p + 36.412478 * _p * m.k;
  m.A[4] = 84.66 * _p + 18.206239 * _p * m.k;
  m.A[5] = 141.74 * _p + 53.303771 * _p * m.k;
  m.A[6] = 207.17 * _p + 2.453732 * _p * m.k;
  m.A[7] = 154.84 * _p + 7.30686 * _p * m.k;
  m.A[8] = 34.52 * _p + 27.261239 * _p * m.k;
  m.A[9] = 207.19 * _p + .121824 * _p * m.k;
  m.A[10] = 291.34 * _p + 1.844379 * _p * m.k;
  m.A[11] = 161.72 * _p + 24.198154 * _p * m.k;
  m.A[12] = 239.56 * _p + 25.513099 * _p * m.k;
  m.A[13] = 331.55 * _p + 3.592518 * _p * m.k;
  return m;
}

/// new coefficients
const _nc = [
  -.4072,
  .17241,
  .01608,
  .01039,
  .00739,
  -.00514,
  .00208,
  -.00111,
  -.00057,
  .00056,
  -.00042,
  .00042,
  .00038,
  -.00024,
  -.00017,
  -.00007,
  .00004,
  .00004,
  .00003,
  .00003,
  -.00003,
  .00003,
  -.00002,
  -.00002,
  .00002,
];

/// full coefficients
const _fc = [
  -.40614,
  .17302,
  .01614,
  .01043,
  .00734,
  -.00515,
  .00209,
  -.00111,
  -.00057,
  .00056,
  -.00042,
  .00042,
  .00038,
  -.00024,
  -.00017,
  -.00007,
  .00004,
  .00004,
  .00003,
  .00003,
  -.00003,
  .00003,
  -.00002,
  -.00002,
  .00002,
];
