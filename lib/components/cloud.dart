import 'dart:math';
import 'package:flutter/widgets.dart';

import 'constants.dart';
import '../screens/game_object.dart';
import 'sprite.dart';

List<Sprite> cloudSprites = [
  Sprite()
    ..imagePath = "assets/images/cl.png"
    ..imageWidth = 130
    ..imageHeight = 50,
  Sprite()
    ..imagePath = "assets/images/cl.png"
    ..imageWidth = 160
    ..imageHeight = 70,
  Sprite()
    ..imagePath = "assets/images/cl.png"
    ..imageWidth = 120
    ..imageHeight = 30,
  Sprite()
    ..imagePath = "assets/images/cl.png"
    ..imageWidth = 120
    ..imageHeight = 30,
];

class Cloud extends GameObject {
  final Offset worldLocation;
  final Sprite sprite;

  Cloud({required this.worldLocation})
      : sprite = cloudSprites[Random().nextInt(cloudSprites.length)]; // Random sprite

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (worldLocation.dx - runDistance) * worldToPixelRatio / 5,
      screenSize.height / 2 - sprite.imageHeight - worldLocation.dy,
      sprite.imageWidth.toDouble(),
      sprite.imageHeight.toDouble(),
    );
  }

  @override
  Widget render() {
    return Image.asset(sprite.imagePath);
  }
}
