import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:orbit_music/screens/settings_screen/language/language.dart';

import '../screens/home_screen/chip_screen.dart';
import '../screens/home_screen/home_screen.dart';
import '../screens/home_screen/search_screen/search_screen.dart';
import '../screens/saved_screen/saved_screen.dart';
import '../screens/main_screen/main_screen.dart';
import '../screens/main_screen/player_screen.dart';
import '../screens/browse_screen/browse_screen.dart';
import '../screens/settings_screen/about/about_screen.dart';
import '../screens/settings_screen/appearence/appearence_screen.dart';
import '../screens/settings_screen/backup_restore/backup_restore_screen.dart';
import '../screens/settings_screen/content/content_screen.dart';
import '../screens/settings_screen/playback/audio_and_playback_screen.dart';
import '../screens/settings_screen/playback/equalizer_screen.dart';
import '../screens/settings_screen/settings_screen.dart';

GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => child,
      routes: [
        StatefulShellRoute(
          branches: branches,
          builder: (context, state, navigationShell) =>
              MainScreen(navigationShell: navigationShell),
          navigatorContainerBuilder: (context, navigationShell, children) =>
              MyPageView(
                currentIndex: navigationShell.currentIndex,
                children: children,
              ),
        ),
      ],
    ),
    GoRoute(
      path: '/player',
      pageBuilder: (context, state) {
        String? videoId = state.extra as String?;
        return CustomTransitionPage(
          name: 'player',
          child: PlayerScreen(videoId: videoId),
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slideTween = Tween(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.fastOutSlowIn));

            return SlideTransition(
              position: animation.drive(slideTween),
              child: child,
            );
          },
        );
      },
    ),
  ],
);

List<StatefulShellBranch> branches = [
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'chip',
            builder: (context, state) {
              Map<String, dynamic> args = state.extra as Map<String, dynamic>;
              return ChipScreen(
                title: args['title'] ?? '',
                endpoint: args['endpoint'] ?? {},
              );
            },
          ),
          GoRoute(
            path: 'browse',
            builder: (context, state) {
              Map<String, dynamic> args = state.extra as Map<String, dynamic>;
              return BrowseScreen(endpoint: args);
            },
          ),
        ],
      ),
    ],
  ),
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: '/search',
        builder: (context, state) {
          final query = state.uri.queryParameters['query'] ?? '';
          return SearchScreen(query: query);
        },
      ),
    ],
  ),
  StatefulShellBranch(
    routes: [
      GoRoute(path: '/saved', builder: (context, state) => const SavedScreen()),
    ],
  ),

  // StatefulShellBranch(routes: [
  //   GoRoute(
  //     path: '/ytmusic',
  //     builder: (context, state) => const YTMScreen(),
  //   ),
  // ]),
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'appearence',
            builder: (context, state) => const AppearenceScreen(),
          ),
          GoRoute(
            path: 'language',
            builder: (context, state) => const LanguageSettingsScreen(),
          ),
          GoRoute(
            path: 'content',
            builder: (context, state) => const ContentScreen(),
          ),
          GoRoute(
            path: 'playback',
            builder: (context, state) => const AudioAndPlaybackScreen(),
            routes: [
              GoRoute(
                path: 'equalizer',
                builder: (context, state) => const EqualizerScreen(),
              ),
            ],
          ),
          GoRoute(
            path: 'backup_restore',
            builder: (context, state) => const BackupRestoreScreen(),
          ),
          GoRoute(
            path: 'about',
            builder: (context, state) => const AboutScreen(),
          ),
        ],
      ),
    ],
  ),
];

class MyPageView extends StatefulWidget {
  final int currentIndex;
  final List<Widget> children;

  const MyPageView({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  @override
  MyPageViewState createState() => MyPageViewState();
}

class MyPageViewState extends State<MyPageView> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Container(
        key: ValueKey<int>(widget.currentIndex),
        child: widget.children[widget.currentIndex],
      ),
    );
  }
}
