// Copyright 2020 Shawn Lauzon
// License: MIT

import 'package:test/test.dart';
import 'package:meeus/julian.dart' as julian;

const precision1 = 0.1;
const precision2 = 0.01;
const precision3 = 0.001;
const precision4 = 0.0001;
const precision5 = 0.00001;
const precision6 = 0.000001;
const precision7 = 0.0000001;
const precision8 = 0.00000001;
const precision9 = 0.000000001;

Matcher closeToDateTime(value, Duration delta) => CloseToDateTime(value, delta);

class CloseToDateTime extends Matcher {
  final DateTime _dt;
  final Duration _delta;

  bool _isJD = false;

  CloseToDateTime(value, this._delta)
      : _dt = value is String
            ? DateTime.parse(value)
            : value is num ? julian.jdToDateTime(value) : value;

  @override
  bool matches(item, Map matchState) {
    var dateTime;
    if (item is double) {
      // assume JD
      _isJD = true;
      dateTime = julian.jdToDateTime(item);
      matchState['dateTime'] = dateTime;
    } else if (item is String) {
      dateTime = DateTime.parse(item);
    } else {
      dateTime = item;
    }
    return dateTime.difference(_dt).abs() <= _delta;
  }

  @override
  Description describe(Description description) {
    return description.add(
        '<${_isJD ? julian.dateTimeToJD(_dt).toString() : _dt.toIso8601String()}>');
  }

  @override
  Description describeMismatch(dynamic item, Description mismatchDescription,
      Map matchState, bool verbose) {
    if (_isJD) {
      mismatchDescription
          .add('Is DateTime: ${matchState['dateTime'].toIso8601String()}');
    }
    return mismatchDescription;
  }
}
