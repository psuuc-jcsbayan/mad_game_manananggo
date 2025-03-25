import 'package:flutter/material.dart';
import 'package:manananggo/screens/gamescreen.dart'; // Import your Endless Runner game widget
import 'package:provider/provider.dart';
import '../style/palette.dart';
import 'package:flutter/services.dart'; // Import the services library

class Screen extends StatelessWidget {
  const Screen({Key? key});

  @override
  Widget build(BuildContext context) {
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight, 
    // ]);

    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundLevelSelection,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Endless Runner game widget
          Expanded(
            child: EndlessRunnerGame(), // Replace with your Endless Runner game widget
          ),
        ],
      ),
    );
  }
}
