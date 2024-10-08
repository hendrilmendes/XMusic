
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:xmusic/Screens/Home/home.dart';
import 'package:xmusic/Screens/Library/downloads.dart';
import 'package:xmusic/Screens/Library/nowplaying.dart';
import 'package:xmusic/Screens/Library/playlists.dart';
import 'package:xmusic/Screens/Library/recent.dart';
import 'package:xmusic/Screens/Library/stats.dart';
import 'package:xmusic/Screens/Login/auth.dart';
import 'package:xmusic/Screens/Login/pref.dart';
import 'package:xmusic/Screens/Settings/settings_page.dart';

Widget initialFuntion() {
  return Hive.box('settings').get('userId') != null ? HomePage() : AuthScreen();
}

final Map<String, Widget Function(BuildContext)> namedRoutes = {
  '/': (context) => initialFuntion(),
  '/pref': (context) => const PrefScreen(),
  '/setting': (context) => const SettingsPage(),
  '/playlists': (context) => PlaylistScreen(),
  '/nowplaying': (context) => NowPlaying(),
  '/recent': (context) => RecentlyPlayed(),
  '/downloads': (context) => const Downloads(),
  '/stats': (context) => const Stats(),
};
