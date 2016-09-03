import 'package:test/test.dart';
import 'package:rainbow_vis/rainbow_vis.dart';


main() async {
  group('Rainbow basic features', () {
    setUp(() {});


    test('Default Spectrum', () {
      var rb = new Rainbow(); // by default, range is 0 to 100
      expect(rb[00.00], "ff0000");
      expect(rb[33.33], "ffff00");
      expect(rb[66.67], "00ff00");
      expect(rb[100.0], "0000ff");
    });

    test('From Array', () {
      var rbArray = new Rainbow.fromArray(['red', 'FFFFFF', '#00ff00']);
      rbArray.setNumberRange(-0.5, 0.5);
      var rb = new Rainbow();
      rb.spectrum = ['red', 'FFFFFF', '#00ff00'];
      rb.setNumberRange(-0.5, 0.5);
      for (int i = -5; i <= 5; i++) {
        expect(rb[i], rbArray[i]);
        expect(rb[i], rbArray[i]);
      }
    });

    test('Set Custom Spectrum', () {
      var rb = new Rainbow(minNum: -0.5, maxNum: 0.5); // by default, range is 0 to 100
      rb.spectrum = ['red', 'FFFFFF', '#00ff00'];
      rb.setNumberRange(-0.5, 0.5);
      expect(rb[-5.0], "ff0000");
      expect(rb[-1.0], "ff0000");
      expect(rb[-0.25], "ff8080");
      expect(rb[-0], "ffffff");
      expect(rb[0], "ffffff");
      expect(rb[0.33], "57ff57");
      expect(rb[0.5], "00ff00");
      expect(rb[1.0], "00ff00");
      expect(rb[5.0], "00ff00");
    });
  });

  group('Rainbow exceptions', () {
    setUp(() {});


    test('Invalid ranges', () {
      expect(() => new Rainbow(minNum: 100, maxNum: -10), throwsA(new isInstanceOf<RangeError>()));
      expect(() => new Rainbow(minNum: 100, maxNum: 100), throwsA(new isInstanceOf<RangeError>()));

      Rainbow r = new Rainbow();
      expect(() => r.setNumberRange(2, 1), throwsA(new isInstanceOf<RangeError>()));
    });

    test('Invalid colors', () {
      expect(() => new Rainbow.fromArray(['nosuchcolor', 'FFFFFF', '#00ff00']),
          throwsA(new isInstanceOf<ArgumentError>()));
      expect(() => new Rainbow.fromArray(['FF0000', 'FFFFFF00', '#00ff00']),
          throwsA(new isInstanceOf<ArgumentError>()));
    });

  });
}
