import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xmusic/Screens/Library/liked.dart';
import 'package:xmusic/Screens/LocalMusic/downed_songs.dart';
import 'package:xmusic/Screens/LocalMusic/downed_songs_desktop.dart';
import 'package:xmusic/l10n/app_localizations.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        AppBar(
          title: Text(
            AppLocalizations.of(context)!.library,
            style: TextStyle(color: Theme.of(context).iconTheme.color),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        LibraryTile(
          title: AppLocalizations.of(context)!.nowPlaying,
          icon: Icons.queue_music_rounded,
          onTap: () {
            Navigator.pushNamed(context, '/nowplaying');
          },
        ),
        LibraryTile(
          title: AppLocalizations.of(context)!.lastSession,
          icon: Icons.history_rounded,
          onTap: () {
            Navigator.pushNamed(context, '/recent');
          },
        ),
        LibraryTile(
          title: AppLocalizations.of(context)!.favorites,
          icon: Icons.favorite_rounded,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => LikedSongs(
                      playlistName: 'Favorite Songs',
                      showName: AppLocalizations.of(context)!.favSongs,
                    ),
              ),
            );
          },
        ),
        LibraryTile(
          title: AppLocalizations.of(context)!.myMusic,
          icon: Icons.my_library_music_rounded,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        (Platform.isWindows ||
                                Platform.isLinux ||
                                Platform.isMacOS)
                            ? const DownloadedSongsDesktop()
                            : const DownloadedSongs(showPlaylists: true),
              ),
            );
          },
        ),
        LibraryTile(
          title: AppLocalizations.of(context)!.downs,
          icon: Icons.download_done_rounded,
          onTap: () {
            Navigator.pushNamed(context, '/downloads');
          },
        ),
        LibraryTile(
          title: AppLocalizations.of(context)!.playlists,
          icon: Icons.playlist_play_rounded,
          onTap: () {
            Navigator.pushNamed(context, '/playlists');
          },
        ),
        LibraryTile(
          title: AppLocalizations.of(context)!.stats,
          icon: Icons.auto_graph_rounded,
          onTap: () {
            Navigator.pushNamed(context, '/stats');
          },
        ),
      ],
    );
  }
}

class LibraryTile extends StatelessWidget {
  const LibraryTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).iconTheme.color),
      ),
      subtitle:
          subtitle != null
              ? Text(
                subtitle!,
                style: TextStyle(color: Theme.of(context).iconTheme.color),
              )
              : null,
      leading: Icon(icon, color: Theme.of(context).iconTheme.color),
      onTap: onTap,
    );
  }
}
