import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/history_screen.dart';
import 'screens/level_selection_screen.dart';
import 'screens/main_menu_screen.dart';
import 'settings/settings_screen.dart';
import 'style/my_transition.dart';

/// The router describes the game's navigational hierarchy, from the main
/// screen through settings screens all the way to each individual level.
/// 
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenuScreen(key: Key('main menu')),
      routes: [
        GoRoute(
            path: 'play',
            pageBuilder: (context, state) => buildMyTransition<void>(
                  key: ValueKey('play'),
                  color: Colors.black,
                  child: const Screen(
                    key: Key('level selection'),
                  ),
                ),
        ),
        GoRoute(
            path: 'settings',
            pageBuilder: (context, state) => buildMyTransition<void>(
              key: ValueKey('settings'),
              color: Colors.black,
              child: const SettingsScreen(key: Key('settings')),
            ),
          ),
          GoRoute(
            path: 'history',
            pageBuilder: (context, state) => buildMyTransition<void>(
              key: ValueKey('history'),
              color: Colors.black,
              child: const HistoryScreen(key: Key('history')),
            ),
          ),

      ],
    ),
  ],
);
