import 'package:flutter/material.dart';
import 'package:xmusic/l10n/app_localizations.dart';
import 'package:xmusic/APIs/api.dart';
import 'package:xmusic/CustomWidgets/bouncy_sliver_scroll_view.dart';
import 'package:xmusic/CustomWidgets/copy_clipboard.dart';
import 'package:xmusic/CustomWidgets/download_button.dart';
import 'package:xmusic/CustomWidgets/empty_screen.dart';
import 'package:xmusic/CustomWidgets/gradient_containers.dart';
import 'package:xmusic/CustomWidgets/image_card.dart';
import 'package:xmusic/Screens/Common/song_list.dart';
import 'package:xmusic/Screens/Search/artists.dart';

class AlbumSearchPage extends StatefulWidget {
  final String query;
  final String type;

  const AlbumSearchPage({
    super.key,
    required this.query,
    required this.type,
  });

  @override
  _AlbumSearchPageState createState() => _AlbumSearchPageState();
}

class _AlbumSearchPageState extends State<AlbumSearchPage> {
  int page = 1;
  bool loading = false;
  List<Map>? _searchedList;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        page += 1;
        _fetchData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _fetchData() {
    loading = true;
    switch (widget.type) {
      case 'Playlists':
        SaavnAPI()
            .fetchAlbums(
          searchQuery: widget.query,
          type: 'playlist',
          page: page,
        )
            .then((value) {
          final temp = _searchedList ?? [];
          temp.addAll(value);
          setState(() {
            _searchedList = temp;
            loading = false;
          });
        });
      case 'Albums':
        SaavnAPI()
            .fetchAlbums(
          searchQuery: widget.query,
          type: 'album',
          page: page,
        )
            .then((value) {
          final temp = _searchedList ?? [];
          temp.addAll(value);
          setState(() {
            _searchedList = temp;
            loading = false;
          });
        });
      case 'Artists':
        SaavnAPI()
            .fetchAlbums(
          searchQuery: widget.query,
          type: 'artist',
          page: page,
        )
            .then((value) {
          final temp = _searchedList ?? [];
          temp.addAll(value);
          setState(() {
            _searchedList = temp;
            loading = false;
          });
        });
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _searchedList == null
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : _searchedList!.isEmpty
                ? emptyScreen(
                    context,
                    0,
                    ':( ',
                    100,
                    AppLocalizations.of(context)!.sorry,
                    60,
                    AppLocalizations.of(context)!.resultsNotFound,
                    20,
                  )
                : BouncyImageSliverScrollView(
                    scrollController: _scrollController,
                    title: widget.type,
                    placeholderImage: widget.type == 'Artists'
                        ? 'assets/artist.png'
                        : 'assets/album.png',
                    sliverList: SliverList(
                      delegate: SliverChildListDelegate(
                        _searchedList!.map(
                          (Map entry) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 7),
                              child: ListTile(
                                title: Text(
                                  '${entry["title"]}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onLongPress: () {
                                  copyToClipboard(
                                    context: context,
                                    text: '${entry["title"]}',
                                  );
                                },
                                subtitle: entry['subtitle'] == ''
                                    ? null
                                    : Text(
                                        '${entry["subtitle"]}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                leading: imageCard(
                                  elevation: 8,
                                  borderRadius:
                                      widget.type == 'Artists' ? 50.0 : 7.0,
                                  placeholderImage: AssetImage(
                                    widget.type == 'Artists'
                                        ? 'assets/artist.png'
                                        : 'assets/album.png',
                                  ),
                                  imageUrl: entry['image'].toString(),
                                ),
                                trailing: widget.type != 'Albums'
                                    ? null
                                    : AlbumDownloadButton(
                                        albumName: entry['title'].toString(),
                                        albumId: entry['id'].toString(),
                                      ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (_, __, ___) =>
                                          widget.type == 'Artists'
                                              ? ArtistSearchPage(
                                                  data: entry,
                                                  artistId:
                                                      entry['id'].toString(),
                                                )
                                              : SongsListPage(
                                                  listItem: entry,
                                                ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
      ),
    );
  }
}
