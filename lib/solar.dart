// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

/// Solar: Chapter 25, Solar Coordinates.
///
/// Partial implementation:
///
/// 1. Higher accuracy positions are not computed with Appendix III but with
/// full VSOP87 as implemented in package planetposition.
///
/// 2. Higher accuracy correction for aberration (using the formula for
/// variation Δλ on p. 168) is not implemented.  Results for example 25.b
/// already match the full VSOP87 values on p. 165 even with the low accuracy
/// correction for aberration, thus there are no more significant digits that
/// would check a more accurate result.  Also the size of the formula presents
/// significant chance of typographical error.
library solar;

export 'src/solar.dart';
