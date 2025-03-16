import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:xmusic/APIs/api.dart';
import 'package:xmusic/CustomWidgets/download_button.dart';
import 'package:xmusic/CustomWidgets/empty_screen.dart';
import 'package:xmusic/CustomWidgets/gradient_containers.dart';
import 'package:xmusic/CustomWidgets/image_card.dart';
import 'package:xmusic/CustomWidgets/like_button.dart';
import 'package:xmusic/CustomWidgets/media_tile.dart';
import 'package:xmusic/CustomWidgets/on_hover.dart';
import 'package:xmusic/CustomWidgets/search_bar.dart' as searchbar;
import 'package:xmusic/CustomWidgets/snackbar.dart';
import 'package:xmusic/CustomWidgets/song_tile_trailing_menu.dart';
import 'package:xmusic/Helpers/extensions.dart';
import 'package:xmusic/Helpers/format.dart';
import 'package:xmusic/Models/image_quality.dart';
import 'package:xmusic/Screens/Common/song_list.dart';
import 'package:xmusic/Screens/Common/song_list_view.dart';
import 'package:xmusic/Screens/Search/albums.dart';
import 'package:xmusic/Screens/Search/artists.dart';
import 'package:xmusic/Screens/YouTube/youtube_artist.dart';
import 'package:xmusic/Screens/YouTube/youtube_playlist.dart';
import 'package:xmusic/Services/player_service.dart';
import 'package:xmusic/Services/youtube_services.dart';
import 'package:xmusic/Services/ytmusic/yt_music.dart';
import 'package:xmusic/l10n/app_localizations.dart';

class SearchPage extends StatefulWidget {
  final String query;
  final bool fromHome;
  final bool fromDirectSearch;
  final String? searchType;
  final bool autofocus;
  const SearchPage({
    super.key,
    required this.query,
    this.fromHome = false,
    this.fromDirectSearch = false,
    this.searchType,
    this.autofocus = false,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  bool fetchResultCalled = false;
  bool fetched = false;
  bool alertShown = false;
  // bool albumFetched = false;
  bool? fromHome;
  List<Map<dynamic, dynamic>> searchedList = [];
  String searchType =
      Hive.box('settings').get('searchType', defaultValue: 'saavn').toString();
  List searchHistory =
      Hive.box('settings').get('search', defaultValue: []) as List;
  // bool showHistory =
  //     Hive.box('settings').get('showHistory', defaultValue: true) as bool;
  bool liveSearch =
      Hive.box('settings').get('liveSearch', defaultValue: true) as bool;
  final ValueNotifier<List<Map>> topSearch = ValueNotifier<List<Map>>([]);

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.query;
    if (widget.searchType != null) {
      searchType = widget.searchType!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchResults() async {
    // this fetches songs, albums, playlists, artists, etc
    Logger.root.info(
      'fetching search results for ${query == '' ? widget.query : query}',
    );
    switch (searchType) {
      case 'ytm':
        Logger.root.info('calling yt music search');
        YtMusicService()
            .search(query == '' ? widget.query : query)
            .then((value) {
              setState(() {
                final songSection = value.firstWhere(
                  (element) => element['title'] == 'Songs',
                );
                songSection['allowViewAll'] = true;
                searchedList = value;
                fetched = true;
              });
            })
            .catchError((e) {
              Logger.root.severe(
                'Unable to reach the youtube music service due to connection error Error: \n $e',
              );
              setState(() {
                fetched = true;
              });
            });
      case 'yt':
        Logger.root.info('calling youtube search');
        YouTubeServices.instance
            .fetchSearchResults(query == '' ? widget.query : query)
            .then((value) {
              setState(() {
                searchedList = value;
                fetched = true;
              });
            })
            .catchError((e) {
              Logger.root.severe(
                'Unable to reach the youtube service due to connection error Error: \n $e',
              );
              setState(() {
                fetched = true;
              });
            });
      default:
        Logger.root.info('calling saavn search');
        searchedList = await SaavnAPI().fetchSearchResults(
          query == '' ? widget.query : query,
        );
        for (final element in searchedList) {
          if (element['title'] != 'Top Result') {
            element['allowViewAll'] = true;
          }
        }
        setState(() {
          fetched = true;
        });
    }
  }

  Future<void> getTrendingSearch() async {
    topSearch.value = await SaavnAPI().getTopSearches();
  }

  void addToHistory(String title) {
    final tempquery = title.trim();
    if (tempquery == '') {
      return;
    }
    final idx = searchHistory.indexOf(tempquery);
    if (idx != -1) {
      searchHistory.removeAt(idx);
    }
    searchHistory.insert(0, tempquery);
    if (searchHistory.length > 10) {
      searchHistory = searchHistory.sublist(0, 10);
    }
    Hive.box('settings').put('search', searchHistory);
  }

  Widget nothingFound(BuildContext context) {
    if (!alertShown) {
      ShowSnackBar().showSnackBar(
        context,
        AppLocalizations.of(context)!.useVpn,
        duration: const Duration(seconds: 7),
        action: SnackBarAction(
          textColor: Theme.of(context).colorScheme.secondary,
          label: AppLocalizations.of(context)!.useProxy,
          onPressed: () {
            setState(() {
              Hive.box('settings').put('useProxy', true);
              fetched = false;
              fetchResultCalled = false;
              searchedList = [];
            });
          },
        ),
      );
      alertShown = true;
    }
    return emptyScreen(
      context,
      0,
      ':( ',
      100,
      AppLocalizations.of(context)!.sorry,
      60,
      AppLocalizations.of(context)!.resultsNotFound,
      20,
    );
  }

  String getSubTitle(Map item) {
    final type = item['type'];
    switch (type) {
      case 'playlist':
        return 'Playlist • ${(item['subtitle']?.toString() ?? '').isEmpty ? 'JioSaavn' : item['subtitle'].toString().unescape()}';
      case 'song':
        return 'Single';
      case 'show':
        return 'Podcast • ${(item['subtitle']?.toString() ?? '').isEmpty ? 'JioSaavn' : item['subtitle'].toString().unescape()}';
      case 'album':
        final artists =
            item['more_info']?['artistMap']?['artists']
                .map((artist) => artist['name'])
                .toList();
        if (artists != null) {
          return 'Album • ${artists?.join(', ')?.toString().unescape()}';
        } else if (item['subtitle'] != null && item['subtitle'] != '') {
          return 'Album • ${item['subtitle']?.toString().unescape()}';
        }
        return 'Album';
      default:
        final artists =
            item['more_info']?['artistMap']?['artists']
                .map((artist) => artist['name'])
                .toList();
        return artists?.join(', ')?.toString().unescape() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    fromHome ??= widget.fromHome;
    if (!fetchResultCalled) {
      fetchResultCalled = true;
      fromHome! ? getTrendingSearch() : fetchResults();
    }
    double boxSize =
        MediaQuery.sizeOf(context).height > MediaQuery.sizeOf(context).width
            ? MediaQuery.sizeOf(context).width / 2
            : MediaQuery.sizeOf(context).height / 2.5;
    if (boxSize > 250) boxSize = 250;

    return GradientContainer(
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: searchbar.SearchBar(
            controller: _controller,
            liveSearch: liveSearch,
            autofocus: widget.autofocus,
            hintText: AppLocalizations.of(context)!.searchText,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                if ((fromHome ?? false) || widget.fromDirectSearch) {
                  Navigator.pop(context);
                } else {
                  setState(() {
                    fromHome = true;
                    _controller.text = '';
                  });
                }
              },
            ),
            body:
                (fromHome!)
                    ? SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5.0,
                      ),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 65),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Wrap(
                              children: List<Widget>.generate(
                                searchHistory.length,
                                (int index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                      vertical:
                                          (Platform.isWindows ||
                                                  Platform.isLinux ||
                                                  Platform.isMacOS)
                                              ? 5.0
                                              : 0.0,
                                    ),
                                    child: GestureDetector(
                                      child: Chip(
                                        label: Text(
                                          searchHistory[index].toString(),
                                        ),
                                        labelStyle: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodyLarge!.color,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        onDeleted: () {
                                          setState(() {
                                            searchHistory.removeAt(index);
                                            Hive.box(
                                              'settings',
                                            ).put('search', searchHistory);
                                          });
                                        },
                                      ),
                                      onTap: () {
                                        setState(() {
                                          fetched = false;
                                          query =
                                              searchHistory
                                                  .removeAt(index)
                                                  .toString()
                                                  .trim();
                                          addToHistory(query);
                                          _controller.text = query;
                                          _controller.selection =
                                              TextSelection.fromPosition(
                                                TextPosition(
                                                  offset: query.length,
                                                ),
                                              );
                                          fetchResultCalled = false;
                                          fromHome = false;
                                          searchedList = [];
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: topSearch,
                            builder: (
                              BuildContext context,
                              List<Map> value,
                              Widget? child,
                            ) {
                              if (value.isEmpty) return const SizedBox();
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.trendingSearch,
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Wrap(
                                      children: List<
                                        Widget
                                      >.generate(value.length, (int index) {
                                        final subTitle = getSubTitle(
                                          value[index],
                                        );
                                        return GestureDetector(
                                          onLongPress: () {
                                            Feedback.forLongPress(context);
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return InteractiveViewer(
                                                  child: Stack(
                                                    children: [
                                                      GestureDetector(
                                                        onTap:
                                                            () => Navigator.pop(
                                                              context,
                                                            ),
                                                      ),
                                                      AlertDialog(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                15.0,
                                                              ),
                                                        ),
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        content: imageCard(
                                                          borderRadius: 15.0,
                                                          imageUrl:
                                                              value[index]['image']
                                                                  .toString(),
                                                          imageQuality:
                                                              ImageQuality.high,
                                                          boxDimension:
                                                              MediaQuery.sizeOf(
                                                                context,
                                                              ).width *
                                                              0.8,
                                                          placeholderImage:
                                                              (value[index]['type'] ==
                                                                          'playlist' ||
                                                                      value[index]['type'] ==
                                                                          'album')
                                                                  ? const AssetImage(
                                                                    'assets/album.png',
                                                                  )
                                                                  : value[index]['type'] ==
                                                                      'artist'
                                                                  ? const AssetImage(
                                                                    'assets/artist.png',
                                                                  )
                                                                  : const AssetImage(
                                                                    'assets/cover.jpg',
                                                                  ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          onTap: () async {
                                            if (value[index]['type'] ==
                                                'song') {
                                              PlayerInvoke.init(
                                                songsList:
                                                    await FormatResponse.formatSongsInList(
                                                      [value[index]],
                                                    ),
                                                index: 0,
                                                isOffline: false,
                                              );
                                            } else {
                                              if (value[index]['type'] ==
                                                  'artist') {
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    opaque: false,
                                                    pageBuilder:
                                                        (
                                                          _,
                                                          __,
                                                          ___,
                                                        ) => ArtistSearchPage(
                                                          data: value[index],
                                                          artistId:
                                                              value[index]['id']
                                                                  .toString(),
                                                        ),
                                                  ),
                                                );
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    opaque: false,
                                                    pageBuilder:
                                                        (_, __, ___) =>
                                                            SongsListPage(
                                                              listItem:
                                                                  value[index],
                                                            ),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          child: SizedBox(
                                            width: boxSize - 30,
                                            child: HoverBox(
                                              child: imageCard(
                                                margin: const EdgeInsets.all(
                                                  4.0,
                                                ),
                                                borderRadius: 10.0,
                                                imageUrl:
                                                    value[index]['image']
                                                        .toString(),
                                                imageQuality:
                                                    ImageQuality.medium,
                                                placeholderImage:
                                                    (value[index]['type'] ==
                                                                'playlist' ||
                                                            value[index]['type'] ==
                                                                'album')
                                                        ? const AssetImage(
                                                          'assets/album.png',
                                                        )
                                                        : value[index]['type'] ==
                                                            'artist'
                                                        ? const AssetImage(
                                                          'assets/artist.png',
                                                        )
                                                        : const AssetImage(
                                                          'assets/cover.jpg',
                                                        ),
                                              ),
                                              builder: ({
                                                required BuildContext context,
                                                required bool isHover,
                                                Widget? child,
                                              }) {
                                                return Card(
                                                  color:
                                                      isHover
                                                          ? null
                                                          : Colors.transparent,
                                                  elevation: 0,
                                                  margin: EdgeInsets.zero,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10.0,
                                                        ),
                                                  ),
                                                  clipBehavior: Clip.antiAlias,
                                                  child: Column(
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          SizedBox.square(
                                                            dimension:
                                                                isHover
                                                                    ? boxSize -
                                                                        25
                                                                    : boxSize -
                                                                        30,
                                                            child: child,
                                                          ),
                                                          if (isHover &&
                                                              (value[index]['type'] ==
                                                                  'song'))
                                                            Positioned.fill(
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets.all(
                                                                      4.0,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color:
                                                                      Colors
                                                                          .black54,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        10.0,
                                                                      ),
                                                                ),
                                                                child: Center(
                                                                  child: DecoratedBox(
                                                                    decoration: BoxDecoration(
                                                                      color:
                                                                          Colors
                                                                              .black87,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            1000.0,
                                                                          ),
                                                                    ),
                                                                    child: const Icon(
                                                                      Icons
                                                                          .play_arrow_rounded,
                                                                      size:
                                                                          50.0,
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 10.0,
                                                            ),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              value[index]['title']
                                                                      ?.toString()
                                                                      .unescape() ??
                                                                  '',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              softWrap: false,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            if (subTitle != '')
                                                              Text(
                                                                subTitle,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                softWrap: false,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                  fontSize: 11,
                                                                  color:
                                                                      Theme.of(
                                                                            context,
                                                                          )
                                                                          .textTheme
                                                                          .bodySmall!
                                                                          .color,
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    )
                    : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70, left: 15),
                          child:
                              (query.isEmpty && widget.query.isEmpty)
                                  ? null
                                  : Row(
                                    children: getChoices(context, [
                                      {'label': 'Saavn', 'key': 'saavn'},
                                      {'label': 'YT Music', 'key': 'ytm'},
                                      {'label': 'YouTube', 'key': 'yt'},
                                    ]),
                                  ),
                        ),
                        Expanded(
                          child:
                              !fetched
                                  ? const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  )
                                  : (searchedList.isEmpty)
                                  ? nothingFound(context)
                                  : SingleChildScrollView(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                    ),
                                    physics: const BouncingScrollPhysics(),
                                    child: Column(
                                      children:
                                          searchedList.map((Map section) {
                                            final String title =
                                                section['title'].toString();
                                            final List? items =
                                                section['items'] as List?;
                                            String localizedTitle = title;
                                            if (localizedTitle ==
                                                'Top Result') {
                                              localizedTitle =
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.topResult;
                                            } else if (localizedTitle ==
                                                'Artists') {
                                              localizedTitle =
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.artists;
                                            } else if (localizedTitle ==
                                                'Songs') {
                                              localizedTitle =
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.songs;
                                            } else if (localizedTitle ==
                                                'Podcasts') {
                                              localizedTitle =
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.podcasts;
                                            } else if (localizedTitle ==
                                                'Albums') {
                                              localizedTitle =
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.albums;
                                            } else if (localizedTitle ==
                                                'Playlists') {
                                              localizedTitle =
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.playlists;
                                            }

                                            if (items == null ||
                                                items.isEmpty) {
                                              return const SizedBox();
                                            }
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 17,
                                                        right: 15,
                                                        top: 15,
                                                      ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        localizedTitle,
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                      if (section['allowViewAll'] ==
                                                          true)
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap:
                                                                  searchType !=
                                                                          'saavn'
                                                                      ? () {
                                                                        Navigator.push(
                                                                          context,
                                                                          PageRouteBuilder(
                                                                            opaque:
                                                                                false,
                                                                            pageBuilder:
                                                                                (
                                                                                  _,
                                                                                  __,
                                                                                  ___,
                                                                                ) => SongsListViewPage(
                                                                                  onTap: (
                                                                                    index,
                                                                                    listItems,
                                                                                  ) async {
                                                                                    final Map response = await YtMusicService().getSongData(
                                                                                      videoId:
                                                                                          items[index]['id'].toString(),
                                                                                      data:
                                                                                          items[index]
                                                                                              as Map,
                                                                                      quality:
                                                                                          Hive.box(
                                                                                                'settings',
                                                                                              )
                                                                                              .get(
                                                                                                'ytQuality',
                                                                                                defaultValue:
                                                                                                    'Low',
                                                                                              )
                                                                                              .toString(),
                                                                                    );

                                                                                    if (response.isNotEmpty) {
                                                                                      PlayerInvoke.init(
                                                                                        songsList: [
                                                                                          response,
                                                                                        ],
                                                                                        index:
                                                                                            0,
                                                                                        isOffline:
                                                                                            false,
                                                                                      );
                                                                                    } else {
                                                                                      ShowSnackBar().showSnackBar(
                                                                                        context,
                                                                                        AppLocalizations.of(
                                                                                          context,
                                                                                        )!.ytLiveAlert,
                                                                                      );
                                                                                    }
                                                                                  },
                                                                                  title:
                                                                                      title,
                                                                                  subtitle:
                                                                                      '\nShowing Search Results for',
                                                                                  secondarySubtitle:
                                                                                      '"${(query == '' ? widget.query : query).capitalize()}"',
                                                                                  listItemsTitle:
                                                                                      title,
                                                                                  loadFunction: () {
                                                                                    return YtMusicService().searchSongs(
                                                                                      query ==
                                                                                              ''
                                                                                          ? widget.query
                                                                                          : query,
                                                                                    );
                                                                                  },
                                                                                ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      : () {
                                                                        if (title ==
                                                                                'Albums' ||
                                                                            title ==
                                                                                'Playlists' ||
                                                                            title ==
                                                                                'Artists') {
                                                                          Navigator.push(
                                                                            context,
                                                                            PageRouteBuilder(
                                                                              opaque:
                                                                                  false,
                                                                              pageBuilder:
                                                                                  (
                                                                                    _,
                                                                                    __,
                                                                                    ___,
                                                                                  ) => AlbumSearchPage(
                                                                                    query:
                                                                                        query ==
                                                                                                ''
                                                                                            ? widget.query
                                                                                            : query,
                                                                                    type:
                                                                                        title,
                                                                                  ),
                                                                            ),
                                                                          );
                                                                        }
                                                                        if (title ==
                                                                                'Songs' ||
                                                                            title ==
                                                                                'Podcasts') {
                                                                          Navigator.push(
                                                                            context,
                                                                            PageRouteBuilder(
                                                                              opaque:
                                                                                  false,
                                                                              pageBuilder:
                                                                                  (
                                                                                    _,
                                                                                    __,
                                                                                    ___,
                                                                                  ) => SongsListPage(
                                                                                    listItem: {
                                                                                      'id':
                                                                                          query ==
                                                                                                  ''
                                                                                              ? widget.query
                                                                                              : query,
                                                                                      'title':
                                                                                          title,
                                                                                      'type':
                                                                                          title ==
                                                                                                  'Songs'
                                                                                              ? 'songs'
                                                                                              : 'shows',
                                                                                    },
                                                                                  ),
                                                                            ),
                                                                          );
                                                                        }
                                                                      },
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    AppLocalizations.of(
                                                                      context,
                                                                    )!.viewAll,
                                                                    style: TextStyle(
                                                                      color:
                                                                          Theme.of(
                                                                            context,
                                                                          ).textTheme.bodySmall!.color,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                    ),
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .chevron_right_rounded,
                                                                    color:
                                                                        Theme.of(
                                                                              context,
                                                                            )
                                                                            .textTheme
                                                                            .bodySmall!
                                                                            .color,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                ListView.builder(
                                                  itemCount: items.length,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                      ),
                                                  itemBuilder: (
                                                    context,
                                                    index,
                                                  ) {
                                                    final int count =
                                                        items[index]['count']
                                                            as int? ??
                                                        0;
                                                    final itemType =
                                                        items[index]['type']
                                                            ?.toString()
                                                            .toLowerCase() ??
                                                        'video';
                                                    String countText = '';
                                                    if (count >= 1) {
                                                      count > 1
                                                          ? countText =
                                                              '$count ${AppLocalizations.of(context)!.songs}'
                                                          : countText =
                                                              '$count ${AppLocalizations.of(context)!.song}';
                                                    }
                                                    return MediaTile(
                                                      title:
                                                          items[index]['title']
                                                              .toString(),
                                                      subtitle:
                                                          countText != ''
                                                              ? '$countText\n${items[index]["subtitle"]}'
                                                              : items[index]['subtitle']
                                                                  .toString(),
                                                      isThreeLine:
                                                          countText != '',
                                                      leadingWidget: imageCard(
                                                        borderRadius:
                                                            title ==
                                                                        'Artists' ||
                                                                    itemType ==
                                                                        'artist'
                                                                ? 50.0
                                                                : 7.0,
                                                        placeholderImage: AssetImage(
                                                          title == 'Artists' ||
                                                                  itemType ==
                                                                      'artist'
                                                              ? 'assets/artist.png'
                                                              : title == 'Songs'
                                                              ? 'assets/cover.jpg'
                                                              : 'assets/album.png',
                                                        ),
                                                        imageUrl:
                                                            items[index]['image']
                                                                .toString(),
                                                      ),
                                                      trailingWidget:
                                                          searchType != 'saavn'
                                                              ? ((itemType ==
                                                                          'song' ||
                                                                      itemType ==
                                                                          'video')
                                                                  ? YtSongTileTrailingMenu(
                                                                    data:
                                                                        items[index]
                                                                            as Map,
                                                                  )
                                                                  : null)
                                                              : title !=
                                                                  'Albums'
                                                              ? title == 'Songs'
                                                                  ? Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      DownloadButton(
                                                                        data:
                                                                            items[index]
                                                                                as Map,
                                                                        icon:
                                                                            'download',
                                                                      ),
                                                                      LikeButton(
                                                                        mediaItem:
                                                                            null,
                                                                        data:
                                                                            items[index]
                                                                                as Map,
                                                                      ),
                                                                      SongTileTrailingMenu(
                                                                        data:
                                                                            items[index]
                                                                                as Map,
                                                                      ),
                                                                    ],
                                                                  )
                                                                  : null
                                                              : AlbumDownloadButton(
                                                                albumName:
                                                                    items[index]['title']
                                                                        .toString(),
                                                                albumId:
                                                                    items[index]['id']
                                                                        .toString(),
                                                              ),
                                                      onTap:
                                                          searchType != 'saavn'
                                                              ? () async {
                                                                if (itemType ==
                                                                    'artist') {
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (
                                                                            context,
                                                                          ) => YouTubeArtist(
                                                                            artistId:
                                                                                items[index]['id'].toString(),
                                                                          ),
                                                                    ),
                                                                  );
                                                                }
                                                                if (itemType ==
                                                                        'playlist' ||
                                                                    itemType ==
                                                                        'album' ||
                                                                    itemType ==
                                                                        'single') {
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (
                                                                            context,
                                                                          ) => YouTubePlaylist(
                                                                            playlistId:
                                                                                items[index]['id'].toString(),
                                                                            type:
                                                                                itemType ==
                                                                                            'album' ||
                                                                                        itemType ==
                                                                                            'single'
                                                                                    ? 'album'
                                                                                    : 'playlist',
                                                                          ),
                                                                    ),
                                                                  );
                                                                }
                                                                if (itemType ==
                                                                        'song' ||
                                                                    itemType ==
                                                                        'video') {
                                                                  final Map?
                                                                  response =
                                                                      (itemType ==
                                                                              'video')
                                                                          ? await YouTubeServices.instance.formatVideoFromId(
                                                                            id:
                                                                                items[index]['id'].toString(),
                                                                            data:
                                                                                items[index]
                                                                                    as Map,
                                                                          )
                                                                          : await YtMusicService().getSongData(
                                                                            videoId:
                                                                                items[index]['id'].toString(),
                                                                            data:
                                                                                items[index]
                                                                                    as Map,
                                                                          );

                                                                  if (response !=
                                                                      null) {
                                                                    PlayerInvoke.init(
                                                                      songsList: [
                                                                        response,
                                                                      ],
                                                                      index: 0,
                                                                      isOffline:
                                                                          false,
                                                                    );
                                                                  } else {
                                                                    ShowSnackBar().showSnackBar(
                                                                      context,
                                                                      AppLocalizations.of(
                                                                        context,
                                                                      )!.ytLiveAlert,
                                                                    );
                                                                  }
                                                                }
                                                              }
                                                              : () {
                                                                if (title ==
                                                                    'Songs') {
                                                                  PlayerInvoke.init(
                                                                    songsList: [
                                                                      items[index],
                                                                    ],
                                                                    index: 0,
                                                                    isOffline:
                                                                        false,
                                                                  );
                                                                } else {
                                                                  Navigator.push(
                                                                    context,
                                                                    PageRouteBuilder(
                                                                      opaque:
                                                                          false,
                                                                      pageBuilder:
                                                                          (
                                                                            _,
                                                                            __,
                                                                            ___,
                                                                          ) =>
                                                                              title ==
                                                                                          'Artists' ||
                                                                                      (title ==
                                                                                              'Top Result' &&
                                                                                          items[0]['type'] ==
                                                                                              'artist')
                                                                                  ? ArtistSearchPage(
                                                                                    data:
                                                                                        items[index]
                                                                                            as Map,
                                                                                    artistId:
                                                                                        items[index]['id']
                                                                                            as String,
                                                                                  )
                                                                                  : SongsListPage(
                                                                                    listItem:
                                                                                        items[index]
                                                                                            as Map,
                                                                                  ),
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                    );
                                                  },
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                    ),
                                  ),
                        ),
                      ],
                    ),
            onSubmitted: (String submittedQuery) {
              setState(() {
                fetched = false;
                fromHome = false;
                fetchResultCalled = false;
                query = submittedQuery;
                _controller.text = submittedQuery;
                _controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: query.length),
                );
                searchedList = [];
              });
            },
            onQueryChanged: (changedQuery) {
              return YouTubeServices.instance.getSearchSuggestions(
                query: changedQuery,
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> getChoices(
    BuildContext context,
    List<Map<String, String>> choices,
  ) {
    return choices.map((Map<String, String> element) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.5),
        child: ChoiceChip(
          label: Text(element['label']!),
          selectedColor:
          // ignore: deprecated_member_use
          Theme.of(context).colorScheme.secondary.withOpacity(0.2),
          labelStyle: TextStyle(
            color:
                searchType == element['key']
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).textTheme.bodyLarge!.color,
            fontWeight:
                searchType == element['key']
                    ? FontWeight.w600
                    : FontWeight.normal,
          ),
          selected: searchType == element['key'],
          onSelected: (bool selected) {
            if (selected) {
              searchType = element['key']!;
              fetched = false;
              fetchResultCalled = false;
              Hive.box('settings').put('searchType', element['key']);
              if (element['key'] == 'ytm' || element['key'] == 'yt') {
                Hive.box(
                  'settings',
                ).put('searchYtMusic', element['key'] == 'ytm');
              }
              setState(() {});
            }
          },
        ),
      );
    }).toList();
  }
}
