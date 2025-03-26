import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/startbg1.png',
            fit: BoxFit.cover,
          ),
          // Content
          Container(
            color: Colors.black.withOpacity(0.6), // For readability
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'The Legend of the Manananggal',
                    style: TextStyle(
                      fontFamily: 'Permanent Marker',
                      fontSize: 28,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '''The Manananggal is one of the most feared creatures in Philippine folklore. Known for its terrifying ability to detach its upper torso from its lower body and fly into the night with bat-like wings, the Manananggal preys on unsuspecting victims.

Legends say it especially targets pregnant women and sleeping people, using its long, sharp tongue to suck their blood. People believe garlic, salt, and ash can be used to ward off or kill the creature by preventing it from reattaching to its lower half.

This mythological creature symbolizes the rich, spooky stories passed down through generations in the Philippines.''',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  Text('''Disclaimer: The developer does not claim ownership or rights to any copyrighted material used in the game, including but not limited to images, sound effects, and background music. 
                  All credits goes to the right owner. ''',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back', style: TextStyle(                  
                      fontFamily: 'Permanent Marker',
                      color: Colors.red
),),
                  ),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
