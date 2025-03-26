import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'constants.dart';
import '../screens/game_object.dart';
import 'sprite.dart';

List<Sprite> dinoNight = [
  Sprite()
    ..imagePath = "assets/images/m/m1.png"
    ..imageWidth = 92
    ..imageHeight = 100,
  Sprite()
    ..imagePath = "assets/images/m/m2.png"
    ..imageWidth = 92
    ..imageHeight = 100,
  Sprite()
    ..imagePath = "assets/images/m/m3.png"
    ..imageWidth = 92
    ..imageHeight = 100,
  Sprite()
    ..imagePath = "assets/images/m/m4.png"
    ..imageWidth = 92
    ..imageHeight = 100,
  Sprite()
    ..imagePath = "assets/images/m/m5.png"
    ..imageWidth = 92
    ..imageHeight = 100,
  Sprite()
    ..imagePath = "assets/images/m/m6.png"
    ..imageWidth = 92
    ..imageHeight = 100,
];


List<Sprite> dinoDay = [
  Sprite()
    ..imagePath = "assets/images/eagle.gif"
    ..imageWidth = 92
    ..imageHeight = 100,
  
];


enum DinoState {
  jumping,
  running,
  dead,
}

class Dino extends GameObject {
  Sprite currentSprite;
  double dispY = 0;
  double velY = 0;
  DinoState state = DinoState.running;
  bool isNight = false;

  Dino() : currentSprite = dinoDay[0]; // Initialize with day sprites

  @override
  Widget render() {
    return Image.asset(currentSprite.imagePath);
  }

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      screenSize.width / 10,
      screenSize.height / 1.5 - currentSprite.imageHeight - dispY,
      currentSprite.imageWidth.toDouble(),
      currentSprite.imageHeight.toDouble(),
    );
  }

  @override
  void update(Duration lastUpdate, Duration? elapsedTime) {
    double elapsedTimeSeconds;
    try {
      List<Sprite> currentDinoSprites = isNight ? dinoNight : dinoDay;
      currentSprite = currentDinoSprites[(elapsedTime!.inMilliseconds / 100).floor() % currentDinoSprites.length];
    } catch (_) {
      currentSprite = isNight ? dinoNight[0] : dinoDay[0];
    }
    try {
      elapsedTimeSeconds = (elapsedTime! - lastUpdate).inMilliseconds / 1000;
    } catch (_) {
      elapsedTimeSeconds = 0;
    }

    dispY += velY * elapsedTimeSeconds;
    if (dispY <= 0) {
      dispY = 0;
      velY = 0;
      state = DinoState.running;
    } else {
      velY -= gravity * elapsedTimeSeconds;
    }
  }

  void jump() {
    if (state != DinoState.jumping) {
      state = DinoState.jumping;
      velY = jumpVelocity;
    }
  }

  void die() {
    currentSprite = isNight ? dinoNight[5] : dinoDay[0]; // dead sprite
    state = DinoState.dead;
  }

}

