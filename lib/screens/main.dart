import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../components/cactus.dart';
import '../components/cloud.dart';
import '../components/dino.dart';
import '../components/bat.dart';
import '../player_progress/persistence/local_storage_player_progress_persistence.dart';
import '../settings/settings.dart';
import 'game_object.dart';
import '../components/ground.dart';
import '../components/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Manananggo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Dino dino = Dino();
  double runVelocity = initialVelocity;
  double runDistance = 0;
  int highScore = 0;
  TextEditingController gravityController =
      TextEditingController(text: gravity.toString());
  TextEditingController accelerationController =
      TextEditingController(text: acceleration.toString());
  TextEditingController jumpVelocityController =
      TextEditingController(text: jumpVelocity.toString());
  TextEditingController runVelocityController =
      TextEditingController(text: initialVelocity.toString());
  TextEditingController dayNightOffestController =
      TextEditingController(text: dayNightOffest.toString());

  late AnimationController worldController;
  Duration lastUpdateCall = const Duration();

  List<Cactus> cacti = [Cactus(worldLocation: const Offset(200, 0))];
  List<Ptera> ptera = [Ptera(worldLocation: const Offset(300, -20))];

  List<Ground> ground = [
    Ground(worldLocation: const Offset(0, 0)),
    Ground(worldLocation: Offset(groundSprite.imageWidth / 10, 0))
  ];

  List<Cloud> clouds = [
    Cloud(worldLocation: const Offset(100, 20)),
    Cloud(worldLocation: const Offset(200, 10)),
    Cloud(worldLocation: const Offset(350, -10)),
  ];

  late LocalStoragePlayerProgressPersistence _progressPersistence;

  @override
  void initState() {
    super.initState();
    worldController =
        AnimationController(vsync: this, duration: const Duration(days: 99));
    worldController.addListener(_update);
    _progressPersistence = LocalStoragePlayerProgressPersistence();
    _loadHighScore();
    worldController.forward();
  }

  void _loadHighScore() async {
    int savedScore = await _progressPersistence.getHighestLevelReached();
    setState(() {
      highScore = savedScore;
    });
  }

  void _die() {
    setState(() {
      if (runDistance.toInt() > highScore) {
        highScore = runDistance.toInt();
        _progressPersistence.saveHighestLevelReached(highScore);
      }
      worldController.stop();
      dino.die();
    });

    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Game Over",
                style: TextStyle(fontFamily: 'Permanent Marker')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Oops! You collided with an obstacle!"),
                Text("Score: ${runDistance.toInt()}\nHighest Score: $highScore",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _newGame(); // Restart game
                },
                child: const Text("Play again"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Just close the dialog
                },
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    });
  }

  void _newGame() {
    setState(() {
      highScore = max(highScore,
          runDistance.toInt()); // records dino's high score in new round
      runDistance = 0; // Reset dino's run distance
      runVelocity = initialVelocity; // Reset dino's velocity
      dino.state = DinoState.running;
      dino.dispY = 0;
      worldController.reset();
      cacti = [
        Cactus(worldLocation: const Offset(200, 0)),
        Cactus(worldLocation: const Offset(300, 0)),
        Cactus(worldLocation: const Offset(450, 0)),
      ];

      ground = [
        Ground(worldLocation: const Offset(0, 0)),
        Ground(worldLocation: Offset(groundSprite.imageWidth / 10, 0))
      ];

      clouds = [
        Cloud(worldLocation: const Offset(100, 20)),
        Cloud(worldLocation: const Offset(200, 10)),
        Cloud(worldLocation: const Offset(350, -15)),
        Cloud(worldLocation: const Offset(500, 10)),
        Cloud(worldLocation: const Offset(550, -10)),
      ];

      ptera = [
        Ptera(worldLocation: const Offset(400, 0)),
        Ptera(worldLocation: const Offset(700, 0)),
      ];
      worldController.forward();
    });
  }

  _update() {
    try {
      double elapsedTimeSeconds;
      dino.update(lastUpdateCall, worldController.lastElapsedDuration);
      try {
        elapsedTimeSeconds =
            (worldController.lastElapsedDuration! - lastUpdateCall)
                    .inMilliseconds /
                1000;
      } catch (_) {
        elapsedTimeSeconds = 0;
      }

      runDistance += runVelocity * elapsedTimeSeconds;
      if (runDistance < 0) runDistance = 0;
      runVelocity += acceleration * elapsedTimeSeconds;

      Size screenSize = MediaQuery.of(context).size;

      Rect dinoRect = dino.getRect(screenSize, runDistance);
      for (Cactus cactus in cacti) {
        Rect obstacleRect = cactus.getRect(screenSize, runDistance);
        if (dinoRect.overlaps(obstacleRect.deflate(20))) {
          _die();
        }
        if (obstacleRect.right < 0) {
          setState(() {
            cacti.remove(cactus);
            cacti.add(
              Cactus(
                worldLocation: Offset(
                  runDistance +
                      MediaQuery.of(context).size.width / worlToPixelRatio +
                      Random().nextInt(
                          500) + // Add random distance between obstacles
                      100, // Minimum distance between obstacles
                  0,
                ),
              ),
            );
          });
        }
      }
      // Handle Bat (Flying Birds)
      for (Ptera bird in ptera) {
        Rect birdRect = bird.getRect(screenSize, runDistance);

        // Check collision
        if (dinoRect.overlaps(birdRect.deflate(10))) {
          _die();
        }
        // Remove off-screen bird and spawn new one
        if (birdRect.right < 0) {
          setState(() {
            ptera.remove(bird);
            ptera.add(
              Ptera(
                worldLocation: Offset(
                  runDistance +
                      screenSize.width / worlToPixelRatio +
                      Random().nextInt(600) +
                      200, // Control spacing
                  Random().nextDouble() * -30 - 10, // random flying height
                ),
              ),
            );
          });
        }
      }
      for (Ground groundlet in ground) {
        if (groundlet.getRect(screenSize, runDistance).right < 0) {
          setState(() {
            ground.remove(groundlet);
            ground.add(
              Ground(
                worldLocation: Offset(
                  ground.last.worldLocation.dx + groundSprite.imageWidth / 10,
                  0,
                ),
              ),
            );
          });
        }
      }

      for (Cloud cloud in clouds) {
        if (cloud.getRect(screenSize, runDistance).right < 0) {
          setState(() {
            clouds.remove(cloud);
            clouds.add(
              Cloud(
                worldLocation: Offset(
                  clouds.last.worldLocation.dx +
                      Random().nextInt(100) +
                      MediaQuery.of(context).size.width / worlToPixelRatio,
                  Random().nextInt(30) - 25.0,
                ),
              ),
            );
          });
        }
      }

      lastUpdateCall = worldController.lastElapsedDuration!;
      // Example usage in the game update logic
      // bool isNightTime = runDistance >= 300;
      // dino.updateAppearance(isNightTime);
    } catch (e) {
      //
    }
  }

  @override
  void dispose() {
    gravityController.dispose();
    accelerationController.dispose();
    jumpVelocityController.dispose();
    runVelocityController.dispose();
    dayNightOffestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> children = [];
    final settingsController = context.watch<SettingsController>();
    for (GameObject object in [
      ...clouds,
      ...ground,
      ...cacti,
      ...ptera,
      dino
    ]) {
      children.add(
        AnimatedBuilder(
          animation: worldController,
          builder: (context, _) {
            Rect objectRect = object.getRect(screenSize, runDistance);
            return Positioned(
              left: objectRect.left,
              top: objectRect.top,
              width: objectRect.width,
              height: objectRect.height,
              child: object.render(),
            );
          },
        ),
      );
    }

    // Determine background and character appearance based on score
    bool isNightTime = runDistance >= 300;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 5000),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(isNightTime
                ? 'assets/images/bgs12.png'
                : 'assets/images/bgs5.png'),
            fit: BoxFit.cover,
            colorFilter: isNightTime
                ? const ColorFilter.mode(Colors.black54, BlendMode.darken)
                : const ColorFilter.mode(Colors.white, BlendMode.dst),
          ),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (dino.state == DinoState.running) {
              // Check if the dino is alive
              dino.jump();
            }
            if (dino.state == DinoState.dead) {
              // if dead, it starts a new game
              _newGame();
            }
          },
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              ...children,
              AnimatedBuilder(
                animation: worldController,
                builder: (context, _) {
                  return Positioned(
                    left: 20,
                    top: 70,
                    child: Text(
                      'Current Score: ' + runDistance.toInt().toString(),
                      style: TextStyle(
                        fontFamily: 'Permanent Marker',
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: worldController,
                builder: (context, _) {
                  return Positioned(
                    left: 20,
                    top: 90,
                    child: Text(
                      'Highest Score: ' + highScore.toString(),
                      style: TextStyle(
                        fontFamily: 'Permanent Marker',
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                right: 20,
                top: 20,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: settingsController.audioOn,
                      builder: (context, audioOn, child) {
                        return IconButton(
                          onPressed: () => settingsController.toggleAudioOn(),
                          icon: Icon(
                              audioOn ? Icons.volume_up : Icons.volume_off),
                          color: Colors.white,
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Change Settings"),
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 30,
                                    width: 280,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Gravity:"),
                                        SizedBox(
                                          child: TextField(
                                            controller: gravityController,
                                            key: UniqueKey(),
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                          ),
                                          height: 30,
                                          width: 75,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 30,
                                    width: 280,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Acceleration:"),
                                        SizedBox(
                                          child: TextField(
                                            controller: accelerationController,
                                            key: UniqueKey(),
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                          ),
                                          height: 30,
                                          width: 75,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 30,
                                    width: 280,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Initial Velocity:"),
                                        SizedBox(
                                          child: TextField(
                                            controller: runVelocityController,
                                            key: UniqueKey(),
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                          ),
                                          height: 30,
                                          width: 75,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 30,
                                    width: 280,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Jump Velocity:"),
                                        SizedBox(
                                          child: TextField(
                                            controller: jumpVelocityController,
                                            key: UniqueKey(),
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                          ),
                                          height: 25,
                                          width: 75,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 30,
                                    width: 280,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Day-Night Offset:"),
                                        SizedBox(
                                          child: TextField(
                                            controller:
                                                dayNightOffestController,
                                            key: UniqueKey(),
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                          ),
                                          height: 30,
                                          width: 75,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    gravity = int.parse(gravityController.text);
                                    acceleration = double.parse(
                                        accelerationController.text);
                                    initialVelocity = double.parse(
                                        runVelocityController.text);
                                    jumpVelocity = double.parse(
                                        jumpVelocityController.text);
                                    dayNightOffest = int.parse(
                                        dayNightOffestController.text);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Done",
                                      style: TextStyle(color: Colors.black)),
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                left: screenSize.width / 2 - 70,
                bottom: 10,
                child: TextButton(
                  onPressed: () {
                    _die();
                  },
                  child: const Text("Force Kill Manang",
                      style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
