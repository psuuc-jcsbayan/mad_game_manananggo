import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'constants.dart';
import '../screens/game_object.dart';
import 'sprite.dart';

List<Sprite> dino = [
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

enum DinoState {
  jumping,
  running,
  dead,
}

class Dino extends GameObject {
  Sprite currentSprite = dino[0];
  double dispY = 0;
  double velY = 0;
  DinoState state = DinoState.running;

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
      currentSprite = dino[(elapsedTime!.inMilliseconds / 100).floor() % 2 + 2];
    } catch (_) {
      currentSprite = dino[0];
    }
    try{
      elapsedTimeSeconds = (elapsedTime! - lastUpdate).inMilliseconds / 1000;
    }
    catch(_){
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
    currentSprite = dino[5];
    state = DinoState.dead;
  }
}






