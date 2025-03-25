import 'constants.dart';
import 'package:flutter/widgets.dart';

import '../screens/game_object.dart';
import 'sprite.dart';

List<Sprite> pteraFrames = [
  Sprite()
    ..imagePath = "assets/images/bat/bat11.png"
    ..imageHeight = 80
    ..imageWidth = 92,
  Sprite()
    ..imagePath = "assets/images/bat/bat22.png"
    ..imageHeight = 80
    ..imageWidth = 92,
];

class Ptera extends GameObject {
  // this is a logical location which is translated to pixel coordinates
  final Offset worldLocation;
  int frame = 0;

  Ptera({required this.worldLocation});

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
        (worldLocation.dx - runDistance) * worlToPixelRatio,
        2 / 4 * screenSize.height -
            pteraFrames[frame].imageHeight -
            worldLocation.dy,
        pteraFrames[frame].imageWidth.toDouble(),
        pteraFrames[frame].imageHeight.toDouble());
  }

  @override
  Widget render() {
    return Image.asset(
      pteraFrames[frame].imagePath,
      gaplessPlayback: true,
    );
  }

  @override
  void update(Duration lastUpdate, Duration elapsedTime) {
    frame = (elapsedTime.inMilliseconds / 200).floor() % 2;
  }
}
