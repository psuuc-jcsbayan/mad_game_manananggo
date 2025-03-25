import 'package:manananggo/screens/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';


class EndlessRunnerGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set landscape orientation
     SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

    return OrientationBuilder(
      builder: (context, orientation) {
      final audioController = context.watch<AudioController>();
        return Scaffold(
          body: Stack(
            
            fit: StackFit.expand,
            children: [
              // Background image
              Container(
                child: Image.asset(
                  'assets/images/startbg1.png',
                  fit: BoxFit.cover,
                ),
              ),
              // Centered column for the start button
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Start button
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.transparent)
                      ),
                      onPressed: () {
                      audioController.playSfx(SfxType.buttonTap);
                      Navigator.push(context, MaterialPageRoute(builder:(_)=>MyHomePage ()));
                      },
                      child: Text('PLAY NOW',style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Permanent Marker',
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),),
                    ),
                    SizedBox(height: 10,),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                      ),
                      onPressed: () {
                        // SystemChrome.setPreferredOrientations([
                        //   DeviceOrientation.portraitUp,
                        //   DeviceOrientation.portraitDown,
                        // ]);
                        // Navigator.push(context, MaterialPageRoute(builder: (_)=>MainMenuScreen()));
                        GoRouter.of(context).pop();    
                         audioController.playSfx(SfxType.buttonTap);
                      },
                      child: Text('BACK',style: TextStyle(
                        fontFamily: 'Permanent Marker',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),),
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
