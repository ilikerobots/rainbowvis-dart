import 'package:rainbow_vis/rainbow_vis.dart';

void main() {
  print("Red -> White -> Green");
  var rwg = Rainbow(
      spectrum: ["#ff0000", 'white', '00FF00'],
      rangeStart: -0.5,
      rangeEnd: 0.5);
  for (var v = -1.0; v <= 1.0; v = v + .25) {
    print('rwgb[$v] -> ${rwg[v]}');
  }
  print('');

  print("Red -> Blue");
  var rb = Rainbow(spectrum: ['red', 'blue'], rangeStart: 0, rangeEnd: 10);
  for (var i = 0; i <= 3; i++) {
    var third = 10 * i / 3;
    print('rb[$third] -> ${rb[third]}');
  }
}
