# Meeus

Selected algorithms from the book "Astronomical Algorithms"
by Jean Meeus, following the second edition, copyright 1998,
with corrections as of August 10, 2009.

This Dart library is port of the original Go code written by Sonia Keys and
available at https://github.com/soniakeys/meeus. Many (in fact most) of the
functions have not yet been ported. Pull requests of any functions and their
tests ported will be gladly accepted.

## Library organization

Algorithms are implemented in separate libraries, one for each chapter of the 
book. There is also a library `meeus` which exports all the libraries. It is
recommended to import only the libraries you need using the `as` keyword, as
the names of functions are not always clear without knowing the library name.
There is also a library "base" with additional functions that may not be described
in the book but are useful with multiple other libraries.

## Install

See installation instructions on [pub.dev](https://pub.dev/packages/meeus#-installing-tab-)

We recommend only importing the libraries you need:

```dart
import 'package:meeus/julian.dart' as julian;
import 'package:meeus/moonillum.dart' as moonillum;
```

## Copyright and license

All software in this repository is copyright Shawn Lauzon and licensed with the
MIT license.

