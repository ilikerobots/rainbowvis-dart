import 'dart:math' as math;
import 'package:meta/meta.dart';
import 'package:collection/collection.dart' show ListEquality;

import 'color_gradient.dart';

/// Maps a domain of numbers within a specified range onto a
/// smooth-transitioning color space.
@immutable
class Rainbow {
  final num _rangeStart;

  final num _rangeEnd;

  final bool _includeOpacity;

  final List<ColourGradient> _gradients;

  /// Construct a new Rainbow
  ///
  /// @param spectrum The list of color stops in the transitioning color range.
  /// @param rangeStart The beginning of the numerical domain to map.
  /// @param rangeEnd The end of the numerical domain to map.
  Rainbow(
      {List<String> spectrum = const ['000000', 'ffffff'],
      rangeStart = 0.0,
      rangeEnd = 1.0})
      : _gradients = _spectrumToGradients(spectrum, rangeStart, rangeEnd),
        _rangeStart = rangeStart,
        _rangeEnd = rangeEnd,
        _includeOpacity = _spectrumContainsOpacity(spectrum) {
    assert(spectrum.length >= 2);
    assert(rangeStart != rangeEnd);
    assert(rangeStart != null && rangeEnd != null);
  }

  static List<ColourGradient> _spectrumToGradients(
      final List<String> spectrum, num rangeStart, num rangeEnd) {
    final grads = <ColourGradient>[];
    if (rangeStart != null && rangeEnd != null) {
      num increment = (rangeEnd - rangeStart) / (spectrum.length - 1);
      grads.add(ColourGradient(
          startColour: spectrum[0],
          endColour: spectrum[1],
          startNum: rangeStart,
          endNum: rangeStart + increment));

      for (var i = 1; i < spectrum.length - 1; i++) {
        grads.add(ColourGradient(
            startColour: spectrum[i],
            endColour: spectrum[i + 1],
            startNum: rangeStart + increment * i,
            endNum: rangeStart + increment * (i + 1)));
      }
    }
    return grads;
  }

  /// the gradient definition
  List<String> get spectrum =>
      [_gradients[0].startColour] + _gradients.map((g) => g.endColour).toList();

  /// the range start
  num get rangeStart => _rangeStart;

  /// the range end
  num get rangeEnd => _rangeEnd;

  /// Return the interpolated color along the spectrum for domain item.
  /// If the number is outside the bounds of the domain, then the nearest
  /// edge color is returned.
  String operator [](num number) =>
      _includeOpacity ? _colourAt(number) : _stripOpacity(_colourAt(number));

  String _colourAt(num number) {
    if (_gradients.length == 1) {
      return _gradients[0].colourAt(number);
    } else {
      var segment = (rangeEnd - rangeStart) / (_gradients.length);

      var minRange = math.min(rangeStart, rangeEnd);
      var index = math.min(
          ((math.max(number, minRange) - minRange) / segment.abs()).floor(),
          _gradients.length - 1);
      if (rangeStart > rangeEnd) {
        // then invert the segment
        index = _gradients.length - 1 - index;
      }
      return _gradients[index].colourAt(number);
    }
  }

  static bool _spectrumContainsOpacity(List<String> spectrum) {
    var alphaHexRe = RegExp(r"^#?[0-9a-fA-F]{8}$");
    var hasOpacity = false;
    for (var col in spectrum) {
      if (alphaHexRe.hasMatch(col)) {
        hasOpacity = true;
        break;
      }
    }
    return hasOpacity;
  }

  _stripOpacity(String c) => c.length == 8 ? c.substring(2) : c;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Rainbow &&
          runtimeType == other.runtimeType &&
          _rangeStart == other._rangeStart &&
          _rangeEnd == other._rangeEnd &&
          ListEquality().equals(_gradients, other._gradients);

  @override
  int get hashCode =>
      _rangeStart.hashCode ^ _rangeEnd.hashCode ^ _gradients.hashCode;
}
