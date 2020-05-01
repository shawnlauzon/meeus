// Copyright 2020 Shawn Lauzon
// Copyright 2013 Sonia Keys
// License: MIT

import 'package:test/test.dart';

import 'package:meeus/julian.dart' as julian;
import 'package:meeus/nutation.dart' as nutation;

import 'test_utils.dart';

void main() {
  group('Nutation', () {
    setUp(() {});

    test('Nutation', () {
      // Example 22.a, p. 148.
      final jd = julian.calendarGregorianToJD(1987, 4, 10);
      final result = nutation.nutation(jd);
      final epsilon0 = nutation.meanObliquity(jd);
      final epsilon = epsilon0 + result.deltaEpsilon;

      // Values here manually converted from sexagesimal form below
      expect(result.deltaPsi.deg, closeTo(-0.001052, precision6));
      expect(result.deltaEpsilon.deg, closeTo(0.002623, precision6));
      expect(epsilon0.deg, closeTo(23.440946, precision6));
      expect(epsilon.deg, closeTo(23.443569, precision6));

      // Output:
      // -3″.788
      // +9″.443
      // 23°26′27″.407
      // 23°26′36″.850
    });

// func TestApproxNutation(t *testing.T) {
// 	jd := julian.CalendarGregorianToJD(1987, 4, 10)
// 	deltapsi, deltaEpsilon := nutation.ApproxNutation(jd)
// 	if math.Abs(deltapsi.Sec()+3.788) > .5 {
// 		t.Fatal(deltapsi.Sec())
// 	}
// 	if math.Abs(deltaEpsilon.Sec()-9.443) > .1 {
// 		t.Fatal(deltaEpsilon.Sec())
// 	}
// }

// func TestIAUvsLaskar(t *testing.T) {
// 	for _, y := range []int{1000, 2000, 3000} {
// 		jd := julian.CalendarGregorianToJD(y, 0, 0)
// 		i := nutation.MeanObliquity(jd)
// 		l := nutation.MeanObliquityLaskar(jd)
// 		if math.Abs((i - l).Sec()) > 1 {
// 			t.Fatal(y)
// 		}
// 	}
// 	for _, y := range []int{0, 4000} {
// 		jd := julian.CalendarGregorianToJD(y, 0, 0)
// 		i := nutation.MeanObliquity(jd)
// 		l := nutation.MeanObliquityLaskar(jd)
// 		if math.Abs((i - l).Sec()) > 10 {
// 			t.Fatal(y)
// 		}
// 	}
// }
  });
}
