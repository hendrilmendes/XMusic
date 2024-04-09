
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';
import 'package:xmusic/CustomWidgets/bouncy_playlist_header_scroll_view.dart';
import 'package:xmusic/CustomWidgets/copy_clipboard.dart';
import 'package:xmusic/CustomWidgets/gradient_containers.dart';
import 'package:xmusic/CustomWidgets/image_card.dart';
import 'package:xmusic/CustomWidgets/playlist_popupmenu.dart';
import 'package:xmusic/CustomWidgets/song_tile_trailing_menu.dart';
import 'package:xmusic/Services/player_service.dart';
import 'package:xmusic/Services/youtube_services.dart';
import 'package:xmusic/Services/ytmusic/yt_music.dart';

class YouTubePlaylist extends StatefulWidget {
  final String playlistId;
  final String type;
  // final String playlistName;
  // final String? playlistSubtitle;
  // final String? playlistSecondarySubtitle;
  // final String playlistImage;
  const YouTubePlaylist({
    super.key,
    required this.playlistId,
    this.type = 'playlist',
    // required this.playlistName,
    // required this.playlistSubtitle,
    // required this.playlistSecondarySubtitle,
    // required this.playlistImage,
  });

  @override
  _YouTubePlaylistState createState() => _YouTubePlaylistState();
}

class _YouTubePlaylistState extends State<YouTubePlaylist> {
  bool status = false;
  List<Map> searchedList = [];
  bool fetched = false;
  bool done = true;
  final ScrollController _scrollController = ScrollController();
  String playlistName = '';
  String playlistSubtitle = '';
  String? playlistSecondarySubtitle;
  String playlistImage = '';

  bool isSharePopupShown = false;

  @override
  void initState() {
    if (!status) {
      status = true;
      if (widget.type == 'playlist') {
        YtMusicService().getPlaylistDetails(widget.playlistId).then((value) {
          setState(() {
            try {
              searchedList = value['songs'] as List<Map>? ?? [];
              playlistName = value['name'] as String? ?? '';
              playlistSubtitle = value['subtitle'] as String? ?? '';
              playlistSecondarySubtitle = value['description'] as String?;
              playlistImage = (value['images'] as List?)?.last as String? ?? '';
              fetched = true;
            } catch (e) {
              Logger.root.severe('Error in fetching playlist details', e);
              fetched = true;
            }
          });
        });
      } else if (widget.type == 'album') {
        YtMusicService().getAlbumDetails(widget.playlistId).then((value) {
          setState(() {
            try {
              searchedList = value['songs'] as List<Map>? ?? [];
              playlistName = value['name'] as String? ?? '';
              playlistSubtitle = value['subtitle'] as String? ?? '';
              playlistSecondarySubtitle = value['description'] as String?;
              playlistImage = (value['images'] as List?)?.last as String? ?? '';
              fetched = true;
            } catch (e) {
              Logger.root.severe('Error in fetching playlist details', e);
              fetched = true;
            }
          });
        });
      } else if (widget.type == 'artist') {
        YtMusicService().getArtistDetails(widget.playlistId).then((value) {
          setState(() {
            try {
              searchedList = value['songs'] as List<Map>? ?? [];
              playlistName = value['name'] as String? ?? '';
              playlistSubtitle = value['subtitle'] as String? ?? '';
              playlistSecondarySubtitle = value['description'] as String?;
              playlistImage = (value['images'] as List?)?.last as String? ?? '';
              fetched = true;
            } catch (e) {
              Logger.root.severe('Error in fetching playlist details', e);
              fetched = true;
            }
          });
        });
      }
      // YouTubeServices.instance.getPlaylistSongs(widget.playlistId).then((value) {
      //   if (value.isNotEmpty) {
      //     setState(() {
      //       searchedList = value;
      //       fetched = true;
      //     });
      //   } else {
      //     status = false;
      //   }
      // });
    }
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext cntxt) {
    return GradientContainer(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            if (!fetched)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              BouncyPlaylistHeaderScrollView(
                scrollController: _scrollController,
                title: playlistName,
                subtitle: playlistSubtitle,
                secondarySubtitle: playlistSecondarySubtitle,
                imageUrl: playlistImage,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share_rounded),
                    tooltip: AppLocalizations.of(context)!.share,
                    onPressed: () {
                      if (!isSharePopupShown) {
                        isSharePopupShown = true;

                        Share.share(
                          'https://youtube.com/playlist?list=${widget.playlistId}',
                        ).whenComplete(() {
                          Timer(const Duration(milliseconds: 500), () {
                            isSharePopupShown = false;
                          });
                        });
                      }
                    },
                  ),
                  PlaylistPopupMenu(
                    data: searchedList,
                    title: playlistName,
                  ),
                ],
                onPlayTap: () async {
                  setState(() {
                    done = false;
                  });

                  final Map? response =
                      await YouTubeServices.instance.formatVideoFromId(
                    id: searchedList.first['id'].toString(),
                    data: searchedList.first,
                  );
                  final List<Map> playList = List.from(searchedList);
                  playList[0] = response!;
                  setState(() {
                    done = true;
                  });
                  PlayerInvoke.init(
                    songsList: playList,
                    index: 0,
                    isOffline: false,
                    recommend: false,
                  );
                },
                onShuffleTap: () async {
                  setState(() {
                    done = false;
                  });
                  final List<Map> playList = List.from(searchedList);
                  playList.shuffle();
                  final Map? response =
                      await YouTubeServices.instance.formatVideoFromId(
                    id: playList.first['id'].toString(),
                    data: playList.first,
                  );
                  playList[0] = response!;
                  setState(() {
                    done = true;
                  });
                  PlayerInvoke.init(
                    songsList: playList,
                    index: 0,
                    isOffline: false,
                    recommend: false,
                  );
                },
                sliverList: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      if (searchedList.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            top: 5.0,
                            bottom: 5.0,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.songs,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ...searchedList.map(
                        (Map entry) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 5.0,
                            ),
                            child: ListTile(
                              leading: widget.type == 'album'
                                  ? null
                                  : imageCard(
                                      imageUrl: entry['image'].toString(),
                                    ),
                              title: Text(
                                entry['title'].toString(),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onLongPress: () {
                                copyToClipboard(
                                  context: context,
                                  text: entry['title'].toString(),
                                );
                              },
                              subtitle: entry['subtitle'] == ''
                                  ? null
                                  : Text(
                                      entry['subtitle'].toString(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              onTap: () async {
                                setState(() {
                                  done = false;
                                });
                                final Map? response = await YouTubeServices
                                    .instance
                                    .formatVideoFromId(
                                  id: entry['id'].toString(),
                                  data: entry,
                                );
                                setState(() {
                                  done = true;
                                });
                                PlayerInvoke.init(
                                  songsList: [response],
                                  index: 0,
                                  isOffline: false,
                                );
                                // for (var i = 0;
                                //     i < searchedList.length;
                                //     i++) {
                                //   YouTubeServices.instance
                                //       .formatVideo(
                                //     video: searchedList[i],
                                //     quality: Hive.box('settings')
                                //         .get(
                                //           'ytQuality',
                                //           defaultValue: 'Low',
                                //         )
                                //         .toString(),
                                //   )
                                //       .then((songMap) {
                                //     final MediaItem mediaItem =
                                //         MediaItemConverter.mapToMediaItem(
                                //       songMap!,
                                //     );
                                //     addToNowPlaying(
                                //       context: context,
                                //       mediaItem: mediaItem,
                                //       showNotification: false,
                                //     );
                                //   });
                                // }
                              },
                              trailing: YtSongTileTrailingMenu(data: entry),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            if (!done)
              Center(
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).width / 2,
                  width: MediaQuery.sizeOf(context).width / 2,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: GradientContainer(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.useHome,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.secondary,
                              ),
                              strokeWidth: 5,
                            ),
                            Text(
                              AppLocalizations.of(context)!.fetchingStream,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
