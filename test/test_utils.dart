// Copyright 2020 Shawn Lauzon
// License: MIT

import 'package:test/test.dart';
import 'package:meeus/julian.dart' as julian;
import 'package:unit/unit.dart' as unit;

Matcher closeToAngle(value, unit.Angle delta) => CloseToAngle(value, delta);
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
    if (item is num) {
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

class CloseToAngle extends Matcher {
  final unit.Angle _angle;
  final unit.Angle _delta;

  CloseToAngle(value, this._delta) : _angle = value;

  @override
  bool matches(item, Map matchState) {
    assert(item is unit.Angle);

    return (_angle - item).abs() <= _delta;
  }

  @override
  Description describe(Description description) {
    return description.add(
        'an Angle within <${_delta.rad.toStringAsFixed(4)} rad> / <${_delta.deg.toStringAsFixed(4)}°> '
        'of <${_angle.rad.toStringAsFixed(4)} rad> / <${_angle.deg.toStringAsFixed(4)}°>');
  }

  @override
  Description describeMismatch(dynamic item, Description mismatchDescription,
      Map matchState, bool verbose) {
    mismatchDescription.add(
        'differs by <${(item.rad - _angle.rad).abs()} rad> / <${(item.deg - _angle.deg).abs()}°>');

    return mismatchDescription;
  }
}
