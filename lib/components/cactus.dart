import 'dart:math';
import 'package:flutter/widgets.dart';
import 'constants.dart';
import '../screens/game_object.dart';
import 'sprite.dart';

List<Sprite> ch = [
  Sprite()
    ..imagePath = "assets/images/cross.png"
    ..imageWidth = 47
    ..imageHeight = 80,

  Sprite()
    ..imagePath = "assets/images/garlic.png"
    ..imageWidth = 60
    ..imageHeight = 50,

  Sprite()
    ..imagePath = "assets/images/ch1.png"
    ..imageWidth = 100
    ..imageHeight = 80,

  Sprite()
    ..imagePath = "assets/images/ch2.png"
    ..imageWidth = 100
    ..imageHeight = 80,

  Sprite()
    ..imagePath = "assets/images/ch3.png"
    ..imageWidth = 80
    ..imageHeight = 70,

  Sprite()
    ..imagePath = "assets/images/ch4.png"
    ..imageWidth = 80
    ..imageHeight = 70,
];

class Cactus extends GameObject {
  final Sprite sprite;
  final Offset worldLocation;

  Cactus({required this.worldLocation})
      : sprite = ch[Random().nextInt(ch.length)];

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (worldLocation.dx - runDistance) * worldToPixelRatio,
      screenSize.height / 1.43 - sprite.imageHeight,
      sprite.imageWidth.toDouble(),
      sprite.imageHeight.toDouble(),
    );
  }

  @override
  Widget render() {
    return Image.asset(sprite.imagePath);
  }
}
