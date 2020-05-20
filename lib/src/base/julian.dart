// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

/// The Julian date of the modified Julian date epoch.
const jMod = 2400000.5;

/// The Julian date corresponding to January 1.5, year 2000.
const j2000 = 2451545.0;

// Julian days of common epochs.
// B1900, B1950 from p. 133
// const j1900 = 2415020.0;
// const b1900 = 2415020.3135;
// const b1950 = 2433282.4235;

/// Number of days in a Julian year
const julianYear = 365.25; // days

/// Number of days in a Julian century
const julianCentury = 36525; // days

// Number of days in a Besselian year
// const besselianYear = 365.2421988; // days

/// Returns the number of Julian centuries since J2000.
///
/// The quantity appears as T in a number of time series.
num j2000Century(num jde) {
  // The formula is given in a number of places in the book, for example
  // (12.1) p. 87.
  // (22.1) p. 143.
  // (25.1) p. 163.
  return (jde - j2000) / julianCentury;
}
