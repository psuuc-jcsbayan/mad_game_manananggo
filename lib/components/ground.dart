import 'package:flutter/widgets.dart';
import 'constants.dart';
import '../screens/game_object.dart';
import 'sprite.dart';

Sprite groundSprite = Sprite()
  ..imagePath = "assets/images/ground3.png"
  ..imageWidth = 2399
  ..imageHeight = 40;

class Ground extends GameObject {
  final Offset worldLocation;

  Ground({required this.worldLocation});

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (worldLocation.dx - runDistance) * worldToPixelRatio,
      screenSize.height / 1.4 - groundSprite.imageHeight,
      groundSprite.imageWidth.toDouble(),
      groundSprite.imageHeight.toDouble(),
    );
  }

  @override
  Widget render() {
    return Image.asset(groundSprite.imagePath);
  }
}
