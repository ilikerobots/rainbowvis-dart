/*
RainbowVis-Dart, Derived from RainbowVis-JS
See LICENSE
*/

import 'dart:math' as Math;

///Maps a domain of numbers within a specified range onto a smooth-transitioning color space.
class Rainbow {
  ///The minimum end of the numeric domain
  num minNum;
  ///The maximum end of the numeric domain
  num maxNum;
  List<String> _coloursDefined = ['ff0000', 'ffff00', '00ff00', '0000ff'];
  dynamic _gradients = null;

  Rainbow({minNum: 0.0, maxNum: 100.0}) {
    setNumberRange(minNum, maxNum);
    spectrum = _coloursDefined;
  }

  Rainbow.fromArray(List<String> array, {minNum: 0.0, maxNum: 101.0}) {
    setNumberRange(minNum, maxNum);
    spectrum = array;
  }

  ///Gets the current gradient definition
  List<String> get colours => _coloursDefined;

  ///Set the current spectrum definition. The definition is two or more more equally spaced 'stop points',
  ///between which gradients are produced.
  void set spectrum(List<String> spectrum) {
    if (spectrum.length < 2) {
      throw new Exception('Rainbow must have two or more colours.');
    } else {
      num increment = (maxNum - minNum) / (spectrum.length - 1);
      ColourGradient firstGradient = new ColourGradient();
      firstGradient.setGradient(spectrum[0], spectrum[1]);
      firstGradient.setNumberRange(minNum, minNum + increment);
      _gradients = [firstGradient];

      for (var i = 1; i < spectrum.length - 1; i++) {
        var colourGradient = new ColourGradient();
        colourGradient.setGradient(spectrum[i], spectrum[i + 1]);
        colourGradient.setNumberRange(minNum + increment * i, minNum + increment * (i + 1));
        _gradients.add(colourGradient);
      }

      _coloursDefined = spectrum;
    }
  }

  ///Return the interpolated color along the spectrum for domain item.  If the number is outside the bounds
  ///of the domain, then the nearest edge color is returned.
  operator [](num number) => _colourAt(number);

  String _colourAt(num number) {
    if (_gradients.length == 1) {
      return _gradients[0].colourAt(number);
    } else {
      var segment = (maxNum - minNum) / (_gradients.length);
      var index = Math.min(((Math.max(number, minNum) - minNum) / segment).floor(), _gradients.length - 1);
      return _gradients[index].colourAt(number);
    }
  }

  ///Set the new min and max for the numeric domain
  void setNumberRange(minNumber, maxNumber) {
    if (maxNumber > minNumber) {
      minNum = minNumber;
      maxNum = maxNumber;
      spectrum = _coloursDefined; //reset to calculate
    } else {
      throw new RangeError('maxNumber ($maxNumber) is not greater than minNumber ($minNumber)');
    }
  }
}

class ColourGradient {
  var startColour = 'ff0000';
  var endColour = '0000ff';
  num minNum = 0;
  num maxNum = 100;

  void setGradient(colourStart, colourEnd) {
    startColour = getHexColour(colourStart);
    endColour = getHexColour(colourEnd);
  }

  void setNumberRange(minNumber, maxNumber) {
    if (maxNumber > minNumber) {
      minNum = minNumber;
      maxNum = maxNumber;
    } else {
      throw new Exception('maxNumber ($maxNumber) is not greater than minNumber ($minNumber)');
    }
  }

  String colourAt(number) {
    return calcHex(number, startColour.substring(0, 2), endColour.substring(0, 2))
        + calcHex(number, startColour.substring(2, 4), endColour.substring(2, 4))
        + calcHex(number, startColour.substring(4, 6), endColour.substring(4, 6));
  }

  calcHex(number, channelStart_Base16, channelEnd_Base16) {
    num n = number;
    if (n < minNum) {
      n = minNum;
    }
    if (n > maxNum) {
      n = maxNum;
    }
    num numRange = maxNum - minNum;
    int cStart_Base10 = int.parse(channelStart_Base16, radix: 16);
    int cEnd_Base10 = int.parse(channelEnd_Base16, radix: 16);
    num cPerUnit = (cEnd_Base10 - cStart_Base10) / numRange;
    int c_Base10 = (cPerUnit * (n - minNum) + cStart_Base10).round();
    return formatHex(c_Base10.toRadixString(16));
  }

  String formatHex(hex) {
    if (hex.length == 1) {
      return '0' + hex;
    } else {
      return hex;
    }
  }

  bool isHexColour(string) => new RegExp(r"^#?[0-9a-fA-F]{6}$").hasMatch(string);

  getHexColour(string) {
    if (isHexColour(string)) {
      return string.substring(string.length - 6, string.length);
    } else {
      var name = string.toLowerCase();
      if (_colourNames.containsKey(name)) {
        return _colourNames[name];
      }
      throw new ArgumentError(string + ' is not a valid colour.');
    }
  }

// Extended list of CSS colornames s taken from
// http://www.w3.org/TR/css3-color/#svg-color
  final Map<String, String> _colourNames = {
    "aliceblue": "F0F8FF",
    "antiquewhite": "FAEBD7",
    "aqua": "00FFFF",
    "aquamarine": "7FFFD4",
    "azure": "F0FFFF",
    "beige": "F5F5DC",
    "bisque": "FFE4C4",
    "black": "000000",
    "blanchedalmond": "FFEBCD",
    "blue": "0000FF",
    "blueviolet": "8A2BE2",
    "brown": "A52A2A",
    "burlywood": "DEB887",
    "cadetblue": "5F9EA0",
    "chartreuse": "7FFF00",
    "chocolate": "D2691E",
    "coral": "FF7F50",
    "cornflowerblue": "6495ED",
    "cornsilk": "FFF8DC",
    "crimson": "DC143C",
    "cyan": "00FFFF",
    "darkblue": "00008B",
    "darkcyan": "008B8B",
    "darkgoldenrod": "B8860B",
    "darkgray": "A9A9A9",
    "darkgreen": "006400",
    "darkgrey": "A9A9A9",
    "darkkhaki": "BDB76B",
    "darkmagenta": "8B008B",
    "darkolivegreen": "556B2F",
    "darkorange": "FF8C00",
    "darkorchid": "9932CC",
    "darkred": "8B0000",
    "darksalmon": "E9967A",
    "darkseagreen": "8FBC8F",
    "darkslateblue": "483D8B",
    "darkslategray": "2F4F4F",
    "darkslategrey": "2F4F4F",
    "darkturquoise": "00CED1",
    "darkviolet": "9400D3",
    "deeppink": "FF1493",
    "deepskyblue": "00BFFF",
    "dimgray": "696969",
    "dimgrey": "696969",
    "dodgerblue": "1E90FF",
    "firebrick": "B22222",
    "floralwhite": "FFFAF0",
    "forestgreen": "228B22",
    "fuchsia": "FF00FF",
    "gainsboro": "DCDCDC",
    "ghostwhite": "F8F8FF",
    "gold": "FFD700",
    "goldenrod": "DAA520",
    "gray": "808080",
    "green": "008000",
    "greenyellow": "ADFF2F",
    "grey": "808080",
    "honeydew": "F0FFF0",
    "hotpink": "FF69B4",
    "indianred": "CD5C5C",
    "indigo": "4B0082",
    "ivory": "FFFFF0",
    "khaki": "F0E68C",
    "lavender": "E6E6FA",
    "lavenderblush": "FFF0F5",
    "lawngreen": "7CFC00",
    "lemonchiffon": "FFFACD",
    "lightblue": "ADD8E6",
    "lightcoral": "F08080",
    "lightcyan": "E0FFFF",
    "lightgoldenrodyellow": "FAFAD2",
    "lightgray": "D3D3D3",
    "lightgreen": "90EE90",
    "lightgrey": "D3D3D3",
    "lightpink": "FFB6C1",
    "lightsalmon": "FFA07A",
    "lightseagreen": "20B2AA",
    "lightskyblue": "87CEFA",
    "lightslategray": "778899",
    "lightslategrey": "778899",
    "lightsteelblue": "B0C4DE",
    "lightyellow": "FFFFE0",
    "lime": "00FF00",
    "limegreen": "32CD32",
    "linen": "FAF0E6",
    "magenta": "FF00FF",
    "maroon": "800000",
    "mediumaquamarine": "66CDAA",
    "mediumblue": "0000CD",
    "mediumorchid": "BA55D3",
    "mediumpurple": "9370DB",
    "mediumseagreen": "3CB371",
    "mediumslateblue": "7B68EE",
    "mediumspringgreen": "00FA9A",
    "mediumturquoise": "48D1CC",
    "mediumvioletred": "C71585",
    "midnightblue": "191970",
    "mintcream": "F5FFFA",
    "mistyrose": "FFE4E1",
    "moccasin": "FFE4B5",
    "navajowhite": "FFDEAD",
    "navy": "000080",
    "oldlace": "FDF5E6",
    "olive": "808000",
    "olivedrab": "6B8E23",
    "orange": "FFA500",
    "orangered": "FF4500",
    "orchid": "DA70D6",
    "palegoldenrod": "EEE8AA",
    "palegreen": "98FB98",
    "paleturquoise": "AFEEEE",
    "palevioletred": "DB7093",
    "papayawhip": "FFEFD5",
    "peachpuff": "FFDAB9",
    "peru": "CD853F",
    "pink": "FFC0CB",
    "plum": "DDA0DD",
    "powderblue": "B0E0E6",
    "purple": "800080",
    "red": "FF0000",
    "rosybrown": "BC8F8F",
    "royalblue": "4169E1",
    "saddlebrown": "8B4513",
    "salmon": "FA8072",
    "sandybrown": "F4A460",
    "seagreen": "2E8B57",
    "seashell": "FFF5EE",
    "sienna": "A0522D",
    "silver": "C0C0C0",
    "skyblue": "87CEEB",
    "slateblue": "6A5ACD",
    "slategray": "708090",
    "slategrey": "708090",
    "snow": "FFFAFA",
    "springgreen": "00FF7F",
    "steelblue": "4682B4",
    "tan": "D2B48C",
    "teal": "008080",
    "thistle": "D8BFD8",
    "tomato": "FF6347",
    "turquoise": "40E0D0",
    "violet": "EE82EE",
    "wheat": "F5DEB3",
    "white": "FFFFFF",
    "whitesmoke": "F5F5F5",
    "yellow": "FFFF00",
    "yellowgreen": "9ACD32"
  };
}
