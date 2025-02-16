import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xmusic/l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:xmusic/CustomWidgets/textinput_dialog.dart';
import 'package:xmusic/Screens/Home/saavn.dart';
import 'package:xmusic/Screens/Search/search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String getGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    var greeting = '';

    if (hour < 12) {
      greeting = AppLocalizations.of(context)!.goodMorning;
    } else if (hour < 18) {
      greeting = AppLocalizations.of(context)!.goodAfternoon;
    } else {
      greeting = AppLocalizations.of(context)!.goodEvening;
    }

    return greeting;
  }

  @override
  Widget build(BuildContext context) {
    String name =
        Hive.box('settings').get('name', defaultValue: 'Guest') as String;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool rotated = MediaQuery.sizeOf(context).height < screenWidth;
    return SafeArea(
      child: Stack(
        children: [
          NestedScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            headerSliverBuilder: (
              BuildContext context,
              bool innerBoxScrolled,
            ) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 100,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  // pinned: true,
                  toolbarHeight: 65,
                  // floating: true,
                  automaticallyImplyLeading: false,
                  flexibleSpace: LayoutBuilder(
                    builder: (
                      BuildContext context,
                      BoxConstraints constraints,
                    ) {
                      return FlexibleSpaceBar(
                        titlePadding: EdgeInsets.zero,
                        // collapseMode: CollapseMode.parallax,
                        background: GestureDetector(
                          onTap: () async {
                            showTextInputDialog(
                              context: context,
                              title: AppLocalizations.of(
                                context,
                              )!
                                  .enterName,
                              initialText: name,
                              keyboardType: TextInputType.name,
                              onSubmitted:
                                  (String value, BuildContext context) {
                                Hive.box('settings').put(
                                  'name',
                                  value.trim(),
                                );
                                name = value.trim();
                                Navigator.pop(context);
                              },
                            );
                            // setState(() {});
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const SizedBox(
                                height: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.zero,
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: getGreeting(context),
                                              style: TextStyle(
                                                letterSpacing: 2,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: (Hive.box(
                                                            'settings',
                                                          ).get('name') ==
                                                          null ||
                                                      Hive.box(
                                                            'settings',
                                                          ).get('name') ==
                                                          '')
                                                  ? AppLocalizations.of(
                                                      context,
                                                    )!
                                                      .guest
                                                  : ' ${Hive.box(
                                                      'settings',
                                                    ).get(
                                                        'name',
                                                      ).split(
                                                        ' ',
                                                      )[0]}',
                                              style: const TextStyle(
                                                letterSpacing: 2,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  stretch: true,
                  toolbarHeight: 65,
                  title: Align(
                    child: AnimatedBuilder(
                      animation: _scrollController,
                      builder: (context, child) {
                        return GestureDetector(
                          child: AnimatedContainer(
                            width: (!_scrollController.hasClients ||
                                    _scrollController.positions.length > 1)
                                ? MediaQuery.sizeOf(context).width
                                : max(
                                    MediaQuery.sizeOf(context).width -
                                        _scrollController.offset
                                            .roundToDouble(),
                                    MediaQuery.sizeOf(context).width -
                                        (rotated ? 0 : 75),
                                  ),
                            height: 55.0,
                            duration: const Duration(
                              milliseconds: 150,
                            ),
                            padding: const EdgeInsets.all(2.0),
                            // margin: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                100.0,
                              ),
                              color: Theme.of(context).cardColor,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5.0,
                                  offset: Offset(1.5, 1.5),
                                  // shadow direction: bottom right
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Icon(
                                  CupertinoIcons.search,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!
                                      .searchText,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .color,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchPage(
                                query: '',
                                fromHome: true,
                                autofocus: true,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ];
            },
            body: SaavnHomePage(),
          ),
        ],
      ),
    );
  }
}
