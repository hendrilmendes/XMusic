import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xmusic/CustomWidgets/bottom_nav_bar.dart';
import 'package:xmusic/CustomWidgets/gradient_containers.dart';
import 'package:xmusic/CustomWidgets/miniplayer.dart';
import 'package:xmusic/CustomWidgets/snackbar.dart';
import 'package:xmusic/Helpers/backup_restore.dart';
import 'package:xmusic/Helpers/downloads_checker.dart';
import 'package:xmusic/Helpers/github.dart';
import 'package:xmusic/Helpers/update.dart';
import 'package:xmusic/Screens/Common/routes.dart';
import 'package:xmusic/Screens/Home/home_screen.dart';
import 'package:xmusic/Screens/Library/library.dart';
import 'package:xmusic/Screens/Settings/settings_page.dart';
import 'package:xmusic/Screens/Top Charts/top.dart';
import 'package:xmusic/Screens/YouTube/youtube_home.dart';
import 'package:xmusic/Services/ext_storage_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
  String? appVersion;
  String name =
      Hive.box('settings').get('name', defaultValue: 'Guest') as String;
  bool checkUpdate =
      Hive.box('settings').get('checkUpdate', defaultValue: true) as bool;
  bool autoBackup =
      Hive.box('settings').get('autoBackup', defaultValue: false) as bool;
  List sectionsToShow = Hive.box('settings').get(
    'sectionsToShow',
    defaultValue: ['Home', 'Top Charts', 'YouTube', 'Library', 'Settings'],
  ) as List;
  DateTime? backButtonPressTime;
  final bool useDense = Hive.box('settings').get(
    'useDenseMini',
    defaultValue: false,
  ) as bool;

  void callback() {
    sectionsToShow = Hive.box('settings').get(
      'sectionsToShow',
      defaultValue: ['Home', 'Top Charts', 'YouTube', 'Library', 'Settings'],
    ) as List;
    onItemTapped(0);
    setState(() {});
  }

  void onItemTapped(int index) {
    _selectedIndex.value = index;
    _controller.jumpToTab(
      index,
    );
  }

  Future<bool> handleWillPop(BuildContext? context) async {
    if (context == null) return false;
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            now.difference(backButtonPressTime!) > const Duration(seconds: 3);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = now;
      ShowSnackBar().showSnackBar(
        context,
        AppLocalizations.of(context)!.exitConfirm,
        duration: const Duration(seconds: 2),
        noAction: true,
      );
      return false;
    }
    return true;
  }

  void checkVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appVersion = packageInfo.version;

      if (checkUpdate) {
        Logger.root.info('Checking for update');
        GitHub.getLatestVersion().then((String version) async {
          if (compareVersion(
            version,
            appVersion!,
          )) {
            Logger.root.info('Update available');
            ShowSnackBar().showSnackBar(
              context,
              AppLocalizations.of(context)!.updateAvailable,
              duration: const Duration(seconds: 15),
              action: SnackBarAction(
                textColor: Theme.of(context).colorScheme.secondary,
                label: AppLocalizations.of(context)!.update,
                onPressed: () async {
                  Navigator.pop(context);
                  launchUrl(
                    Uri.parse(
                      'https://github.com/hendrilmendes/XMusic/releases',
                    ),
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
            );
          } else {
            Logger.root.info('No update available');
          }
        });
      }
      if (autoBackup) {
        final List<String> checked = [
          AppLocalizations.of(
            context,
          )!
              .settings,
          AppLocalizations.of(
            context,
          )!
              .downs,
          AppLocalizations.of(
            context,
          )!
              .playlists,
        ];
        final List playlistNames = Hive.box('settings').get(
          'playlistNames',
          defaultValue: ['Favorite Songs'],
        ) as List;
        final Map<String, List> boxNames = {
          AppLocalizations.of(
            context,
          )!
              .settings: ['settings'],
          AppLocalizations.of(
            context,
          )!
              .cache: ['cache'],
          AppLocalizations.of(
            context,
          )!
              .downs: ['downloads'],
          AppLocalizations.of(
            context,
          )!
              .playlists: playlistNames,
        };
        final String autoBackPath = Hive.box('settings').get(
          'autoBackPath',
          defaultValue: '',
        ) as String;
        if (autoBackPath == '') {
          ExtStorageProvider.getExtStorage(
            dirName: 'XMusic/Backups',
            writeAccess: true,
          ).then((value) {
            Hive.box('settings').put('autoBackPath', value);
            createBackup(
              context,
              checked,
              boxNames,
              path: value,
              fileName: 'XMusic_AutoBackup',
              showDialog: false,
            );
          });
        } else {
          createBackup(
            context,
            checked,
            boxNames,
            path: autoBackPath,
            fileName: 'XMusic_AutoBackup',
            showDialog: false,
          ).then(
            (value) => {
              if (value.contains('No such file or directory'))
                {
                  ExtStorageProvider.getExtStorage(
                    dirName: 'XMusic/Backups',
                    writeAccess: true,
                  ).then(
                    (value) {
                      Hive.box('settings').put('autoBackPath', value);
                      createBackup(
                        context,
                        checked,
                        boxNames,
                        path: value,
                        fileName: 'XMusic_AutoBackup',
                      );
                    },
                  ),
                },
            },
          );
        }
      }
    });
    downloadChecker();
  }

  final PageController _pageController = PageController();
  final PersistentTabController _controller = PersistentTabController();

  @override
  void initState() {
    super.initState();
    checkVersion();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool rotated = MediaQuery.sizeOf(context).height < screenWidth;
    final miniplayer = MiniPlayer();
    return GradientContainer(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Row(
          children: [
            if (rotated)
              ValueListenableBuilder(
                valueListenable: _selectedIndex,
                builder: (BuildContext context, int indexValue, Widget? child) {
                  return NavigationRail(
                    minWidth: 70.0,
                    groupAlignment: 0.0,
                    backgroundColor:
                        // Colors.transparent,
                        Theme.of(context).cardColor,
                    selectedIndex: indexValue,
                    onDestinationSelected: (int index) {
                      onItemTapped(index);
                    },
                    labelType: screenWidth > 1050
                        ? NavigationRailLabelType.selected
                        : NavigationRailLabelType.none,
                    selectedLabelTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelTextStyle: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                    ),
                    selectedIconTheme: Theme.of(context).iconTheme.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                    unselectedIconTheme: Theme.of(context).iconTheme,
                    useIndicator: screenWidth < 1050,
                    indicatorColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(),
                    destinations: sectionsToShow.map((e) {
                      switch (e) {
                        case 'Home':
                          return NavigationRailDestination(
                            icon: const Icon(Icons.home_rounded),
                            label: Text(AppLocalizations.of(context)!.home),
                          );
                        case 'Top Charts':
                          return NavigationRailDestination(
                            icon: const Icon(Icons.trending_up_rounded),
                            label: Text(
                              AppLocalizations.of(context)!.topCharts,
                            ),
                          );
                        case 'YouTube':
                          return NavigationRailDestination(
                            icon: const Icon(MdiIcons.youtube),
                            label: Text(AppLocalizations.of(context)!.youTube),
                          );
                        case 'Library':
                          return NavigationRailDestination(
                            icon: const Icon(Icons.my_library_music_rounded),
                            label: Text(AppLocalizations.of(context)!.library),
                          );
                        default:
                          return NavigationRailDestination(
                            icon: const Icon(Icons.settings_rounded),
                            label: Text(
                              AppLocalizations.of(context)!.settings,
                            ),
                          );
                      }
                    }).toList(),
                  );
                },
              ),
            Expanded(
              child: PersistentTabView.custom(
                context,
                controller: _controller,
                itemCount: sectionsToShow.length,
                onWillPop: (context) => handleWillPop(context),
                navBarHeight: 60 +
                    (rotated ? 0 : 70) +
                    (useDense ? 0 : 10) +
                    (rotated && useDense ? 10 : 0),
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : Colors.white,
                screens: sectionsToShow.map((section) {
                  switch (section) {
                    case 'Home':
                      return CustomNavBarScreen(
                        routeAndNavigatorSettings: RouteAndNavigatorSettings(
                          routes: namedRoutes,
                        ),
                        screen: const HomeScreen(),
                      );
                    case 'Top Charts':
                      return CustomNavBarScreen(
                        routeAndNavigatorSettings: RouteAndNavigatorSettings(
                          routes: namedRoutes,
                        ),
                        screen: TopCharts(pageController: _pageController),
                      );
                    case 'YouTube':
                      return CustomNavBarScreen(
                        routeAndNavigatorSettings: RouteAndNavigatorSettings(
                          routes: namedRoutes,
                        ),
                        screen: const YouTube(),
                      );
                    case 'Library':
                      return CustomNavBarScreen(
                        routeAndNavigatorSettings: RouteAndNavigatorSettings(
                          routes: namedRoutes,
                        ),
                        screen: const LibraryPage(),
                      );
                    default:
                      return CustomNavBarScreen(
                        screen: SettingsPage(callback: callback),
                      );
                  }
                }).toList(),
                customWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    miniplayer,
                    if (!rotated)
                      ValueListenableBuilder(
                        valueListenable: _selectedIndex,
                        builder: (context, indexValue, child) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            height: 60,
                            child: CustomBottomNavBar(
                              currentIndex: indexValue,
                              backgroundColor: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black.withValues()
                                  : Colors.white.withValues(),
                              onTap: (index) {
                                onItemTapped(index);
                              },
                              items: _navBarItems(context),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<CustomBottomNavBarItem> _navBarItems(BuildContext context) {
    return sectionsToShow.map((section) {
      switch (section) {
        case 'Home':
          return CustomBottomNavBarItem(
            icon: const Icon(Icons.home_rounded),
            title: Text(AppLocalizations.of(context)!.home),
            selectedColor: Theme.of(context).colorScheme.secondary,
          );
        case 'Top Charts':
          return CustomBottomNavBarItem(
            icon: const Icon(Icons.trending_up_rounded),
            title: Text(AppLocalizations.of(context)!.topCharts),
            selectedColor: Theme.of(context).colorScheme.secondary,
          );
        case 'YouTube':
          return CustomBottomNavBarItem(
            icon: const Icon(MdiIcons.youtube),
            title: Text(AppLocalizations.of(context)!.youTube),
            selectedColor: Theme.of(context).colorScheme.secondary,
          );
        case 'Library':
          return CustomBottomNavBarItem(
            icon: const Icon(Icons.my_library_music_rounded),
            title: Text(AppLocalizations.of(context)!.library),
            selectedColor: Theme.of(context).colorScheme.secondary,
          );
        default:
          return CustomBottomNavBarItem(
            icon: const Icon(Icons.settings_rounded),
            title: Text(AppLocalizations.of(context)!.settings),
            selectedColor: Theme.of(context).colorScheme.secondary,
          );
      }
    }).toList();
  }
}
