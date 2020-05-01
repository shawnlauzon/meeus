import 'package:meeus/julian.dart' as julian;
import 'package:meeus/moonphase.dart' as moonphase;

void main() {
  final fullMoonJD = moonphase.full(2020);
  final date = julian.jdToDateTime(fullMoonJD);
  print('The full moon nearest to Jan 1, 2020 is ${date}');
}
