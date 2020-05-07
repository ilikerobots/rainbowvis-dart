import 'package:meta/meta.dart';

/// Maps a domain of numbers within a specified range between two colors
@immutable
class ColourGradient {
  /// Color at the beginning of the range
  final String startColour;

  /// Color at the end of the range
  final String endColour;

  /// Start of the number domain
  final num startNum;

  /// End of the number domain
  final num endNum;

  ///Construct a gradient
  ColourGradient(
      {this.startColour = "000000",
      this.endColour = "ffffff",
      this.startNum = 0.0,
      this.endNum = 1.0})
      : super() {
    assert(startNum != endNum);
    assert(startNum != null && endNum != null);
    assert(_isValidColor(startColour));
    assert(_isValidColor(endColour));
  }

  ///The interpolated color
  String colourAt(num number) {
    final startHex = _getHexColour(startColour);
    final endHex = _getHexColour(endColour);
    return _calcHex(number, startHex.substring(0, 2), endHex.substring(0, 2)) +
        _calcHex(number, startHex.substring(2, 4), endHex.substring(2, 4)) +
        _calcHex(number, startHex.substring(4, 6), endHex.substring(4, 6));
  }

  _calcHex(num number, String channelStartBase16, String channelEndBase16) {
    var n = number;
    var isAscending = startNum < endNum;
    if (isAscending) {
      if (n < startNum) {
        n = startNum;
      }
      if (n > endNum) {
        n = endNum;
      }
    } else {
      if (n > startNum) {
        n = startNum;
      }
      if (n < endNum) {
        n = endNum;
      }
    }
    var numRange = endNum - startNum;
    var cStartBase10 = int.parse(channelStartBase16, radix: 16);
    var cEndBase10 = int.parse(channelEndBase16, radix: 16);
    var cPerUnit = (cEndBase10 - cStartBase10) / numRange;
    var cBase10 = (cPerUnit * (n - startNum) + cStartBase10).round();
    return _formatHex(cBase10.toRadixString(16));
  }

  String _formatHex(String hex) {
    if (hex.length == 1) {
      return "0$hex";
    } else {
      return hex;
    }
  }

  static bool _isHexColour(string) =>
      RegExp(r"^#?[0-9a-fA-F]{6}$").hasMatch(string);

  static bool _isValidColor(string) {
    return _getHexColour(string) != null;
  }

  static String _getHexColour(string) {
    if (_isHexColour(string)) {
      return string.substring(string.length - 6, string.length);
    } else {
      var name = string.toLowerCase();
      if (_colourNames.containsKey(name)) {
        return _colourNames[name];
      }
      return null;
    }
  }

// Extended list of CSS colornames s taken from
// http://www.w3.org/TR/css3-color/#svg-color
  static final Map<String, String> _colourNames = const {
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColourGradient &&
          runtimeType == other.runtimeType &&
          startColour == other.startColour &&
          endColour == other.endColour &&
          startNum == other.startNum &&
          endNum == other.endNum;

  @override
  int get hashCode =>
      startColour.hashCode ^
      endColour.hashCode ^
      startNum.hashCode ^
      endNum.hashCode;
}
