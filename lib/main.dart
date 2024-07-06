import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';
import 'package:logging/logging.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:path_provider/path_provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sizer/sizer.dart';
import 'package:xmusic/Helpers/config.dart';
import 'package:xmusic/Helpers/handle_native.dart';
import 'package:xmusic/Helpers/import_export_playlist.dart';
import 'package:xmusic/Helpers/logging.dart';
import 'package:xmusic/Helpers/route_handler.dart';
import 'package:xmusic/Screens/Common/routes.dart';
import 'package:xmusic/Screens/Player/audioplayer.dart';
import 'package:xmusic/constants/constants.dart';
import 'package:xmusic/constants/languagecodes.dart';
import 'package:xmusic/providers/audio_service_provider.dart';
import 'package:xmusic/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Paint.enableDithering = true; No longer needed

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await Hive.initFlutter('XMusic/Database');
  } else if (Platform.isIOS) {
    await Hive.initFlutter('Database');
  } else {
    await Hive.initFlutter();
  }
  for (final box in hiveBoxes) {
    await openHiveBox(
      box['name'].toString(),
      limit: box['limit'] as bool? ?? false,
    );
  }
  if (Platform.isAndroid) {
    setOptimalDisplayMode();
  }
  await startService();
  runApp(MyApp());
}

Future<void> setOptimalDisplayMode() async {
  await FlutterDisplayMode.setHighRefreshRate();
  // final List<DisplayMode> supported = await FlutterDisplayMode.supported;
  // final DisplayMode active = await FlutterDisplayMode.active;

  // final List<DisplayMode> sameResolution = supported
  //     .where(
  //       (DisplayMode m) => m.width == active.width && m.height == active.height,
  //     )
  //     .toList()
  //   ..sort(
  //     (DisplayMode a, DisplayMode b) => b.refreshRate.compareTo(a.refreshRate),
  //   );

  // final DisplayMode mostOptimalMode =
  //     sameResolution.isNotEmpty ? sameResolution.first : active;

  // await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
}

Future<void> startService() async {
  await initializeLogging();
  MetadataGod.initialize();
  final audioHandlerHelper = AudioHandlerHelper();
  final AudioPlayerHandler audioHandler =
      await audioHandlerHelper.getAudioHandler();
  GetIt.I.registerSingleton<AudioPlayerHandler>(audioHandler);
  GetIt.I.registerSingleton<MyTheme>(MyTheme());
}

Future<void> openHiveBox(String boxName, {bool limit = false}) async {
  final box = await Hive.openBox(boxName).onError((error, stackTrace) async {
    Logger.root.severe('Failed to open $boxName Box', error, stackTrace);
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dirPath = dir.path;
    File dbFile = File('$dirPath/$boxName.hive');
    File lockFile = File('$dirPath/$boxName.lock');
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      dbFile = File('$dirPath/XMusic/$boxName.hive');
      lockFile = File('$dirPath/XMusic/$boxName.lock');
    }
    await dbFile.delete();
    await lockFile.delete();
    await Hive.openBox(boxName);
    throw 'Failed to open $boxName Box\nError: $error';
  });
  // clear box if it grows large
  if (limit && box.length > 500) {
    box.clear();
  }
}

/// Called when Doing Background Work initiated from Widget
@pragma('vm:entry-point')
Future<void> backgroundCallback(Uri? data) async {
  if (data?.host == 'controls') {
    final audioHandler = await AudioHandlerHelper().getAudioHandler();
    if (data?.path == '/play') {
      audioHandler.play();
    } else if (data?.path == '/pause') {
      audioHandler.pause();
    } else if (data?.path == '/skipNext') {
      audioHandler.skipToNext();
    } else if (data?.path == '/skipPrevious') {
      audioHandler.skipToPrevious();
    }

    await HomeWidget.saveWidgetData<String>(
      'title',
      audioHandler.mediaItem.value?.title,
    );
    await HomeWidget.saveWidgetData<String>(
      'subtitle',
      audioHandler.mediaItem.value?.displaySubtitle,
    );
    await HomeWidget.updateWidget(name: 'XMusicWidget');
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  // ignore: unreachable_from_main
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', '');
  late StreamSubscription _intentDataStreamSubscription;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    HomeWidget.setAppGroupId('com.github.hendrilmendes.music');
    HomeWidget.registerInteractivityCallback(backgroundCallback);
    final String systemLangCode = Platform.localeName.substring(0, 2);
    final String? lang = Hive.box('settings').get('lang') as String?;
    if (lang == null &&
        LanguageCodes.languageCodes.values.contains(systemLangCode)) {
      _locale = Locale(systemLangCode);
    } else {
      _locale =
          Locale(LanguageCodes.languageCodes[lang ?? 'Portuguese'] ?? 'pt');
    }

    AppTheme.currentTheme.addListener(() {
      setState(() {});
    });

    if (Platform.isAndroid || Platform.isIOS) {
      // For sharing or opening urls/text/files coming from outside the app while the app is in the memory
      _intentDataStreamSubscription =
          ReceiveSharingIntent.instance.getMediaStream().listen(
        (List<SharedMediaFile> value) {
          if (value.isNotEmpty) {
            Logger.root.info('Received intent on stream: $value');
            for (final file in value) {
              if (file.type == SharedMediaType.text ||
                  file.type == SharedMediaType.url) {
                handleSharedText(file.path, navigatorKey);
              }
              if (file.type == SharedMediaType.file) {
                if (file.path.endsWith('.json')) {
                  final List playlistNames = Hive.box('settings')
                          .get('playlistNames')
                          ?.toList() as List? ??
                      ['Favorite Songs'];
                  importFilePlaylist(
                    null,
                    playlistNames,
                    path: file.path,
                    pickFile: false,
                  ).then(
                    (value) =>
                        navigatorKey.currentState?.pushNamed('/playlists'),
                  );
                }
              }
            }
          }
        },
        onError: (err) {
          Logger.root.severe('ERROR in getMediaStream', err);
        },
      );

      // For sharing files coming from outside the app while the app is closed
      ReceiveSharingIntent.instance
          .getInitialMedia()
          .then((List<SharedMediaFile> value) {
        if (value.isNotEmpty) {
          Logger.root.info('Received Intent initially: $value');
          for (final file in value) {
            if (file.type == SharedMediaType.text ||
                file.type == SharedMediaType.url) {
              handleSharedText(file.path, navigatorKey);
            }
            if (file.type == SharedMediaType.file) {
              if (file.path.endsWith('.json')) {
                final List playlistNames = Hive.box('settings')
                        .get('playlistNames')
                        ?.toList() as List? ??
                    ['Favorite Songs'];
                importFilePlaylist(
                  null,
                  playlistNames,
                  path: file.path,
                  pickFile: false,
                ).then(
                  (value) => navigatorKey.currentState?.pushNamed('/playlists'),
                );
              }
            }
          }
          ReceiveSharingIntent.instance.reset();
        }
      }).onError((error, stackTrace) {
        Logger.root.severe('ERROR in getInitialMedia', error);
      });
    }
  }

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizerUtil.setScreenSize(constraints, orientation);
            return MaterialApp(
              title: 'XMusic',
              restorationScopeId: 'XMusic',
              debugShowCheckedModeBanner: false,
              themeMode: AppTheme.themeMode,
              theme: AppTheme.lightTheme(
                context: context,
              ),
              darkTheme: AppTheme.darkTheme(
                context: context,
              ),
              locale: _locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: LanguageCodes.languageCodes.entries
                  .map((languageCode) => Locale(languageCode.value, ''))
                  .toList(),
              routes: namedRoutes,
              navigatorKey: navigatorKey,
              onGenerateRoute: (RouteSettings settings) {
                if (settings.name == '/player') {
                  return PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (_, __, ___) => const PlayScreen(),
                  );
                }
                return HandleRoute.handleRoute(settings.name);
              },
            );
          },
        );
      },
    );
  }
}
