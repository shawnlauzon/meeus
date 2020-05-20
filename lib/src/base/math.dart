// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

/// Evaluates a polynomal with coefficients c at x.  The constant
/// term is [c.first].  The function panics with an empty coefficient list.
num horner(num x, List<num> c) {
  var i = c.length - 1;
  var y = c[i];
  while (i > 0) {
    i--;
    y = y * x + c[i]; // sorry, no fused multiply-add in Go
  }
  return y;
}

/// Returns the integer floor of the fractional value (x / y).
///
/// It uses integer math only, so is more efficient than using floating point
/// intermediate values.  This function can be used in many places where INT()
/// appears in AA.  As with built in integer division, it panics with y == 0.
int floorDiv(int x, y) {
  var q = x ~/ y;
  if ((x < 0) != (y < 0) && x % y != 0) {
    q--;
  }
  return q;
}

/// Modf returns integer and fractional floating-point numbers
/// that sum to f. Both values have the same sign as f.
ModfResult modf(num v) {
  final a = v.truncate();
  final b = v - a;
  return ModfResult(a, b);
}

/// Integer and fractional floating-point numbers that sum to some value.
class ModfResult {
  /// Integer part
  final int intPart;

  /// Fractional part
  final num fracPart;

  const ModfResult(this.intPart, this.fracPart);
}
