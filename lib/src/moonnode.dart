// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

/// Moonnode: Chapter 51, Passages of the Moon through the Nodes.

import 'dart:math' as math;

import 'base.dart' as base;

/// Returns the date of passage of the Moon through an ascending node.
///
/// Argument [year] is a decimal year specifying a date near the event.
//
/// Returned is the jde of the event nearest the given date.
num ascending(num year) {
  return _node(year, 0);
}

/// Returns the date of passage of the Moon through a descending node.
///
/// Argument [year] is a decimal year specifying a date near the event.
///
/// Returned is the jde of the event nearest the given date.
num descending(num year) {
  return _node(year, .5);
}

num _node(num y, num h) {
  var k = (y - 2000.05) * 13.4223; // (50.1) p. 355
  k = (k - h + .5).floor() + h; // snap to half orbit
  const p = math.pi / 180;
  const ck = 1 / 1342.23;
  final T = k * ck;
  final D = base.horner(T, [
    183.638 * p,
    331.73735682 * p / ck,
    .0014852 * p,
    .00000209 * p,
    -.00000001 * p
  ]);
  final M = base.horner(
      T, [17.4006 * p, 26.8203725 * p / ck, .0001186 * p, .00000006 * p]);
  final Mprime = base.horner(T, [
    38.3776 * p,
    355.52747313 * p / ck,
    .0123499 * p,
    .000014627 * p,
    -.000000069 * p
  ]);
  final omega = base.horner(T, [
    123.9767 * p,
    -1.44098956 * p / ck,
    .0020608 * p,
    .00000214 * p,
    -.000000016 * p
  ]);
  final V = base.horner(T, [299.75 * p, 132.85 * p, -.009173 * p]);
  final P = omega + 272.75 * p - 2.3 * p * T;
  final E = base.horner(T, [1, -.002516, -.0000074]);
  return base.horner(T, [
        2451565.1619,
        27.212220817 / ck,
        .0002762,
        .000000021,
        -.000000000088
      ]) +
      -.4721 * math.sin(Mprime) +
      -.1649 * math.sin(2 * D) +
      -.0868 * math.sin(2 * D - Mprime) +
      .0084 * math.sin(2 * D + Mprime) +
      -.0083 * math.sin(2 * D - M) * E +
      -.0039 * math.sin(2 * D - M - Mprime) * E +
      .0034 * math.sin(2 * Mprime) +
      -.0031 * math.sin(2 * (D - Mprime)) +
      .003 * math.sin(2 * D + M) * E +
      .0028 * math.sin(M - Mprime) * E +
      .0026 * math.sin(M) * E +
      .0025 * math.sin(4 * D) +
      .0024 * math.sin(D) +
      .0022 * math.sin(M + Mprime) * E +
      .0017 * math.sin(omega) +
      .0014 * math.sin(4 * D - Mprime) +
      .0005 * math.sin(2 * D + M - Mprime) * E +
      .0004 * math.sin(2 * D - M + Mprime) * E +
      -.0003 * math.sin(2 * (D - M)) * E +
      .0003 * math.sin(4 * D - M) * E +
      .0003 * math.sin(V) +
      .0003 * math.sin(P);
}
