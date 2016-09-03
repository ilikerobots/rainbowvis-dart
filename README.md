# rainbowvis-dart

[![Pub](https://img.shields.io/pub/v/rainbow_vis.svg?maxAge=2592000?style=flat-square)](https://pub.dartlang.org/packages/rainbow_vis)
[![Travis](https://img.shields.io/travis/ilikerobots/rainbowvis-dart.svg?maxAge=2592000?style=flat-square)](https://travis-ci.org/ilikerobots/rainbowvis-dart)

Color data visualization; easily map numbers to a smooth-transitioning color legend. 
This is a port of the [RainbowVis-JS](https://github.com/anomal/RainbowVis-JS)
written by [anomal](https://github.com/anomal). 

## Usage

Instantiate a Rainbow, e.g.

```dart
  Rainbow rb0 = new Rainbow(); //[0,100],red-yellow-green-blue
  Rainbow rb1 = new Rainbow(minNum:-10, maxNum: 10); 
  Rainbow rb2 = new Rainbow.fromArray(['red', 'FFFFFF', '#00ff00']);
  Rainbow rb3 = new Rainbow.fromArray(['red', 'blue'], minNum: -0.5, maxNum: 0.5);
```


To interpolate a color among the spectrum, use the list access operator, e.g.
```dart
  Rainbow rb0 = new Rainbow(minNum:-10, maxNum: 10); 
  var myColdColor = rb0[-9.32];
  var myWarmCOlor = rb0[8.44];
```


## Testing

To run on vm (default): ```pub run test```  As usual, tests can be run on other platforms with ```-p<platform>```



