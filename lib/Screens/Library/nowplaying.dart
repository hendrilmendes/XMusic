
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:xmusic/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:xmusic/CustomWidgets/bouncy_sliver_scroll_view.dart';
import 'package:xmusic/CustomWidgets/empty_screen.dart';
import 'package:xmusic/CustomWidgets/gradient_containers.dart';
import 'package:xmusic/Screens/Player/audioplayer.dart';

class NowPlaying extends StatefulWidget {
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  final AudioPlayerHandler audioHandler = GetIt.I<AudioPlayerHandler>();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: StreamBuilder<PlaybackState>(
        stream: audioHandler.playbackState,
        builder: (context, snapshot) {
          final playbackState = snapshot.data;
          final processingState = playbackState?.processingState;
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: processingState != AudioProcessingState.idle
                ? null
                : AppBar(
                    title: Text(AppLocalizations.of(context)!.nowPlaying),
                    centerTitle: true,
                    elevation: 0,
                  ),
            body: processingState == AudioProcessingState.idle
                ? emptyScreen(
                    context,
                    3,
                    AppLocalizations.of(context)!.nothingIs,
                    18.0,
                    AppLocalizations.of(context)!.playingCap,
                    60,
                    AppLocalizations.of(context)!.playSomething,
                    23.0,
                  )
                : StreamBuilder<MediaItem?>(
                    stream: audioHandler.mediaItem,
                    builder: (context, snapshot) {
                      final mediaItem = snapshot.data;
                      return mediaItem == null
                          ? const SizedBox()
                          : BouncyImageSliverScrollView(
                              scrollController: _scrollController,
                              title: AppLocalizations.of(context)!.nowPlaying,
                              localImage: mediaItem.artUri!
                                  .toString()
                                  .startsWith('file:'),
                              imageUrl: mediaItem.artUri!
                                      .toString()
                                      .startsWith('file:')
                                  ? mediaItem.artUri!.toFilePath()
                                  : mediaItem.artUri!.toString(),
                              sliverList: SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    NowPlayingStream(
                                      audioHandler: audioHandler,
                                    ),
                                  ],
                                ),
                              ),
                            );
                    },
                  ),
          );
        },
      ),
    );
  }
}
