// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

/// Julian: Chapter 7, Julian day.
///
/// Under "General remarks", Meeus describes the INT function as used in the
/// book.  In some contexts, math.Floor might be suitable, but I think more
/// often, the functions base.FloorDiv or base.FloorDiv64 will be more
/// appropriate.  See documentation in package base.
///
/// On p. 63, Modified Julian Day is defined.  See constant JMod in package
/// base.
///
/// See also related functions JulianToGregorian and GregorianToJulian in
/// package jm.
library julian;

export 'src/julian.dart';
