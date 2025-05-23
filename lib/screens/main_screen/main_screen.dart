import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:window_manager/window_manager.dart';

import '../../generated/l10n.dart';
import '../../themes/text_styles.dart';
import '../../utils/adaptive_widgets/adaptive_widgets.dart';
import '../../utils/bottom_modals.dart';
import '../../utils/check_update.dart';
import '../browse_screen/browse_screen.dart';
import 'bottom_player.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.navigationShell})
    : super(key: key ?? const ValueKey('MainScreen'));
  final StatefulNavigationShell navigationShell;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WindowListener {
  late StreamSubscription _intentSub;
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
    if (Platform.isAndroid) {
      _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((
        value,
      ) {
        if (value.isNotEmpty) _handleIntent(value.first);
      });

      ReceiveSharingIntent.instance.getInitialMedia().then((value) {
        if (value.isNotEmpty) _handleIntent(value.first);
        ReceiveSharingIntent.instance.reset();
      });
    }

    _update();
  }

  _handleIntent(SharedMediaFile value) {
    if (value.mimeType == 'text/plain' &&
        value.path.contains('music.youtube.com')) {
      Uri? uri = Uri.tryParse(value.path);
      if (uri != null) {
        if (uri.pathSegments.first == 'watch' &&
            uri.queryParameters['v'] != null) {
          context.push('/player', extra: uri.queryParameters['v']);
        } else if (uri.pathSegments.first == 'playlist' &&
            uri.queryParameters['list'] != null) {
          String id = uri.queryParameters['list']!;
          Navigator.push(
            context,
            AdaptivePageRoute.create(
              (_) => BrowseScreen(
                endpoint: {'browseId': id.startsWith('VL') ? id : 'VL$id'},
              ),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _intentSub.cancel();
    super.dispose();
  }

  _update() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    BaseDeviceInfo deviceInfo = await deviceInfoPlugin.deviceInfo;

    UpdateInfo? updateInfo = await checkUpdate(deviceInfo: deviceInfo);

    if (updateInfo != null && mounted) {
      Modals.showUpdateDialog(context, updateInfo);
    }
  }

  void _goBranch(int index) {
    if (index != widget.navigationShell.currentIndex) {
      widget.navigationShell.goBranch(
        index,
        initialLocation: index == widget.navigationShell.currentIndex,
      );
    }
  }

  @override
  void onWindowClose() async {
    windowManager.destroy();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Platform.isWindows
        ? _buildWindowsMain(_goBranch, widget.navigationShell)
        : Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (screenWidth >= 450)
                      NavigationRail(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        labelType: NavigationRailLabelType.none,
                        selectedLabelTextStyle: smallTextStyle(
                          context,
                          bold: true,
                        ),
                        extended: (screenWidth > 1000),
                        onDestinationSelected: _goBranch,
                        destinations: [
                          NavigationRailDestination(
                            selectedIcon: const Icon(
                              CupertinoIcons.music_house_fill,
                            ),
                            icon: const Icon(CupertinoIcons.music_house),
                            label: Text(
                              S.of(context).Home,
                              style: smallTextStyle(context, bold: false),
                            ),
                          ),
                          NavigationRailDestination(
                            selectedIcon: const Icon(Icons.search_outlined),
                            icon: const Icon(Icons.search_outlined),
                            label: Text(
                              S.of(context).Search,
                              style: smallTextStyle(context, bold: false),
                            ),
                          ),
                          NavigationRailDestination(
                            selectedIcon: const Icon(
                              Icons.library_music_outlined,
                            ),
                            icon: const Icon(Icons.library_music_outlined),
                            label: Text(
                              S.of(context).Saved,
                              style: smallTextStyle(context, bold: false),
                            ),
                          ),
                          NavigationRailDestination(
                            selectedIcon: const Icon(
                              CupertinoIcons.gear_alt_fill,
                            ),
                            icon: const Icon(CupertinoIcons.gear_alt),
                            label: Text(
                              S.of(context).Settings,
                              style: smallTextStyle(context, bold: false),
                            ),
                          ),
                        ],
                        selectedIndex: widget.navigationShell.currentIndex,
                      ),
                    Expanded(child: widget.navigationShell),
                  ],
                ),
              ),
              const BottomPlayer(),
            ],
          ),

          bottomNavigationBar:
              screenWidth < 450
                  ? ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surface.withOpacity(0.8),
                          border: Border(
                            top: BorderSide(
                              color: Theme.of(
                                context,
                              ).dividerColor.withOpacity(0.1),
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: NavigationBarTheme(
                          data: NavigationBarThemeData(
                            height: 65,
                            indicatorColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            iconTheme: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              final isSelected = states.contains(
                                WidgetState.selected,
                              );
                              return IconThemeData(
                                color:
                                    isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.6),
                              );
                            }),
                            labelTextStyle: WidgetStateProperty.resolveWith(
                              (states) => TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color:
                                    states.contains(WidgetState.selected)
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.6),
                              ),
                            ),
                          ),
                          child: NavigationBar(
                            backgroundColor: Colors.transparent,
                            selectedIndex: widget.navigationShell.currentIndex,
                            onDestinationSelected: _goBranch,
                            labelBehavior:
                                NavigationDestinationLabelBehavior.alwaysShow,
                            destinations: [
                              NavigationDestination(
                                icon: const Icon(CupertinoIcons.house),
                                selectedIcon: const Icon(
                                  CupertinoIcons.house_fill,
                                ),
                                label: S.of(context).Home,
                              ),
                              NavigationDestination(
                                icon: const Icon(CupertinoIcons.search),
                                label: S.of(context).Search,
                              ),
                              NavigationDestination(
                                icon: const Icon(CupertinoIcons.music_albums),
                                selectedIcon: const Icon(
                                  CupertinoIcons.music_albums_fill,
                                ),
                                label: S.of(context).Saved,
                              ),
                              NavigationDestination(
                                icon: const Icon(CupertinoIcons.settings),
                                selectedIcon: const Icon(
                                  CupertinoIcons.settings_solid,
                                ),
                                label: S.of(context).Settings,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  : null,
        );
  }

  _buildWindowsMain(
    Function goTOBranch,
    StatefulNavigationShell navigationShell,
  ) {
    return Directionality(
      textDirection: fluent_ui.TextDirection.ltr,
      child: fluent_ui.NavigationView(
        appBar: fluent_ui.NavigationAppBar(
          title: DragToMoveArea(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(S.of(context).xmusic),
            ),
          ),
          leading: fluent_ui.Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Image.asset('assets/images/icon.png', height: 25, width: 25),
          ),
          actions: const WindowButtons(),
        ),
        paneBodyBuilder: (item, body) {
          return Column(
            children: [
              fluent_ui.Expanded(child: navigationShell),
              const BottomPlayer(),
            ],
          );
        },
        pane: fluent_ui.NavigationPane(
          selected: widget.navigationShell.currentIndex,
          size: const fluent_ui.NavigationPaneSize(compactWidth: 60),
          items: [
            fluent_ui.PaneItem(
              key: const ValueKey('/'),
              icon: const Icon(fluent_ui.FluentIcons.home_solid, size: 30),
              title: Text(S.of(context).Home),
              body: const SizedBox.shrink(),
              onTap: () => goTOBranch(0),
            ),
            fluent_ui.PaneItem(
              key: const ValueKey('/search'),
              icon: const Icon(fluent_ui.FluentIcons.search, size: 30),
              title: Text(S.of(context).Search),
              body: const SizedBox.shrink(),
              onTap: () => goTOBranch(1),
            ),
            fluent_ui.PaneItem(
              key: const ValueKey('/saved'),
              icon: const Icon(fluent_ui.FluentIcons.library, size: 30),
              title: Text(S.of(context).Saved),
              body: const SizedBox.shrink(),
              onTap: () => goTOBranch(2),
            ),
          ],
          footerItems: [
            fluent_ui.PaneItem(
              key: const ValueKey('/settings'),
              icon: const Icon(fluent_ui.FluentIcons.settings, size: 30),
              title: Text(S.of(context).Settings),
              body: const SizedBox.shrink(),
              onTap: () => goTOBranch(3),
            ),
          ],
        ),
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final fluent_ui.FluentThemeData theme = fluent_ui.FluentTheme.of(context);

    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
