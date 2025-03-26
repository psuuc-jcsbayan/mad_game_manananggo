import 'package:flutter/material.dart';
import 'package:manananggo/screens/gamescreen.dart';
import 'package:provider/provider.dart';
import '../style/palette.dart';
import 'package:flutter/services.dart';

class Screen extends StatelessWidget {
  const Screen({Key? key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundLevelSelection,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: EndlessRunnerGame(),
          ),
        ],
      ),
    );
  }
}
