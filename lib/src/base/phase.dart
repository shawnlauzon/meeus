// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

import 'package:unit/unit.dart' as unit;

/// Illuminated returns the illuminated fraction of a body's disk.
///
/// The illuminated body can be the Moon or a planet.
///
/// Argument [i] is the phase angle.
double illuminated(unit.Angle i) {
  // (41.1) p. 283, also (48.1) p. 345.
  return (1 + i.cos()) * .5;
}
