import 'package:test/test.dart';
import 'package:rainbow_vis/rainbow_vis.dart';

// ignore: type_annotate_public_apis
main() {
  group('Rainbow basic features', () {
    setUp(() {});

    test('Default Spectrum', () {
      var rb = Rainbow();
      expect(rb[00.00], "000000");
      expect(rb[0.333333], "555555");
      expect(rb[0.666667], "aaaaaa");
      expect(rb[1.0], "ffffff");
    });

    test('Ascending domain', () {
      var rb = Rainbow(
          spectrum: ['red', 'FFFFFF', '#00ff00'],
          rangeStart: -0.5,
          rangeEnd: 0.5);
      expect(rb[-5.0], "ff0000");
      expect(rb[-1.0], "ff0000");
      expect(rb[-0.50], "ff0000");
      expect(rb[-0.25], "ff8080");
      expect(rb[-0], "ffffff");
      expect(rb[0], "ffffff");
      expect(rb[0.33], "57ff57");
      expect(rb[0.5], "00ff00");
      expect(rb[1.0], "00ff00");
      expect(rb[5.0], "00ff00");
    });

    test('Descending Domain', () {
      var rb = Rainbow(
          spectrum: ['red', 'FFFFFF', '#00ff00'],
          rangeStart: 0.5,
          rangeEnd: -0.5);
      expect(rb[-5.0], "00ff00");
      expect(rb[-1.0], "00ff00");
      expect(rb[-0.50], "00ff00");
      expect(rb[-0.33], "57ff57");
      expect(rb[-0], "ffffff");
      expect(rb[0], "ffffff");
      expect(rb[0.25], "ff8080");
      expect(rb[0.5], "ff0000");
      expect(rb[1.0], "ff0000");
      expect(rb[5.0], "ff0000");
    });

    test('Ascending/Descending matches', () {
      var spec = ['red', '215608', '#99AA54', 'blue', '#cf3810'];
      var rbu = Rainbow(spectrum: spec, rangeStart: 100.0, rangeEnd: -50.0);
      var rbd = Rainbow(spectrum: spec, rangeStart: -50.0, rangeEnd: 100.0);
      for (var u = -50.0, d = 100.0; u <= 100.0; u += 1.0, d -= 1) {
        expect(rbu[u], rbd[d]);
      }
    });
  });

  group('Getters', () {
    setUp(() {});
    test('Get spectrum', () {
      var spec = const ['red', 'FFFFFF', '#00ff00'];
      var rb = Rainbow(spectrum: spec, rangeStart: 20, rangeEnd: 50);
      expect(rb.spectrum, spec);
    });
    test('Get range', () {
      var rS = -32.0;
      var rE = 101.320;
      var rb = Rainbow(
          spectrum: const ["blue", "green"], rangeStart: rS, rangeEnd: rE);
      expect(rb.rangeStart, rS);
      expect(rb.rangeEnd, rE);
    });
  });
  group('Equals', () {
    var spec;
    setUp(() {
      spec = const ['red', 'FFFFFF', '#00ff00'];
    });

    test('Is Equal', () {
      expect(
          Rainbow(spectrum: spec, rangeStart: -0.5, rangeEnd: 0.5) ==
              Rainbow(spectrum: spec, rangeStart: -0.5, rangeEnd: 0.5),
          true);
    });
    test('Is Not Equal', () {
      expect(
          Rainbow(spectrum: spec, rangeStart: -0.1, rangeEnd: 0.5) ==
              Rainbow(spectrum: spec, rangeStart: -0.5, rangeEnd: 0.5),
          false);
      expect(
          Rainbow(spectrum: spec, rangeStart: -0.5, rangeEnd: 0.5) ==
              Rainbow(spectrum: spec, rangeStart: 0.5, rangeEnd: -0.5),
          false);
      expect(
          Rainbow(spectrum: spec, rangeStart: -0.5, rangeEnd: 9.5) ==
              Rainbow(spectrum: spec, rangeStart: -0.5, rangeEnd: 0.5),
          false);
      expect(
          Rainbow(
                  spectrum: ['blue', 'green'],
                  rangeStart: -0.5,
                  rangeEnd: 0.5) ==
              Rainbow(spectrum: spec, rangeStart: -0.5, rangeEnd: 0.5),
          false);
    });
  });

  group('Constructor assertions', () {
    setUp(() {});

    test('Invalid ranges', () {
      expect(() => Rainbow(rangeStart: 100, rangeEnd: 100),
          throwsA(isA<AssertionError>()));
      expect(() => Rainbow(rangeStart: -1, rangeEnd: -1),
          throwsA(isA<AssertionError>()));
      expect(() => Rainbow(rangeStart: 1), throwsA(isA<AssertionError>()));
      expect(() => Rainbow(rangeStart: null, rangeEnd: 23.0),
          throwsA(isA<AssertionError>()));
      expect(() => Rainbow(rangeStart: -10, rangeEnd: null),
          throwsA(isA<AssertionError>()));
    });

    test('Invalid colors', () {
      expect(() => Rainbow(spectrum: ['nosuchcolor', 'FFFFFF', '#00ff00']),
          throwsA(isA<AssertionError>()));
      expect(() => Rainbow(spectrum: ['FF0000', 'FFFFFF00', '#00ff00']),
          throwsA(isA<AssertionError>()));
    });
  });
}