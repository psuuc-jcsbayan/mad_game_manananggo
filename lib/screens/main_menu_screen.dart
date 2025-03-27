import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../settings/settings.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/menubg2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40,),
            Center(
              child: Transform.rotate(
                angle: -0.1,
                child: const Text(
                  '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Permanent Marker',
                    fontSize: 55,
                    height: 1,
                    color: Colors.white, // Adjust the text color to match your background
                  ),
                ),
              ),
            ),
            SizedBox(height: 150),
            ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll( Colors.transparent)),
              onPressed: (){
                audioController.playSfx(SfxType.buttonTap);
                GoRouter.of(context).go('/play');
            }, child: const Text('Start',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontFamily: 'Permanent Marker',

              ),)
         ),
           SizedBox(height: 10),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll( Colors.transparent)),
              onPressed: () {
                audioController.playSfx(SfxType.buttonTap);
                GoRouter.of(context).push('/settings');},
                 child: const Text('Settings',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontFamily: 'Permanent Marker',
              ),)),
            SizedBox(height: 10),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll( Colors.transparent)),
              onPressed: () {
                audioController.playSfx(SfxType.buttonTap);
                GoRouter.of(context).push('/history');}, 
              child: const Text('About',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontFamily: 'Permanent Marker',
              ),)),
              SizedBox(height: 10),
            ValueListenableBuilder<bool>(
              valueListenable: settingsController.audioOn,
              builder: (context, audioOn, child) {
                return IconButton(
                  onPressed: () => settingsController.toggleAudioOn(),
                  icon: Icon(audioOn ? Icons.volume_up : Icons.volume_off),
                  color: Colors.white,
                );
              },
            ),            
          ],
        ),
      ),
    );
  }
}
