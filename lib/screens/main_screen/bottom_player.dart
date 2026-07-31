import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/media_player.dart';
import '../../utils/enhanced_image.dart';

class BottomPlayer extends StatelessWidget {
  const BottomPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GetIt.I<MediaPlayer>().currentSongNotifier,
      builder: (context, currentSong, child) {
        Widget content;
        if (currentSong == null) {
          content = const SizedBox.shrink(key: ValueKey('empty_player'));
        } else if (Platform.isWindows) {
          content = Container(
            key: const ValueKey('windows_player'),
            color: fluent_ui.FluentTheme.of(context).scaffoldBackgroundColor,
            child: _buildContent(context, currentSong),
          );
        } else {
          // Apple Music style mini player (floating above bottom nav)
          content = Padding(
            key: const ValueKey('mobile_player'),
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 0,
              top: 4,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).scaffoldBackgroundColor.withOpacity(0.55),
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withOpacity(0.3),
                      width: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: _buildContent(context, currentSong),
                ),
              ),
            ),
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
          switchInCurve: Curves.elasticOut,
          switchOutCurve: Curves.easeInBack,
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1.2),
                end: Offset.zero,
              ).animate(animation),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
            );
          },
          child: content,
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, dynamic currentSong) {
    return GestureDetector(
      onTap: () => context.push('/player'),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Dismissible(
          key: Key('bottomplayer${currentSong.id}'),
          direction: DismissDirection.down,
          confirmDismiss: (direction) async {
            await GetIt.I<MediaPlayer>().stop();
            return true;
          },
          child: Dismissible(
            key: Key(currentSong.id),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                await GetIt.I<MediaPlayer>().player.seekToPrevious();
              } else {
                await GetIt.I<MediaPlayer>().player.seekToNext();
              }
              return Future.value(false);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      // Album art rounded, no glow shadow (Apple style)
                      Hero(
                        tag: 'artwork_${currentSong.id}',
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child:
                                currentSong.extras?['offline'] == true &&
                                    !currentSong.artUri.toString().startsWith(
                                      'https',
                                    )
                                ? Image.file(
                                    File.fromUri(currentSong.artUri!),
                                    height: 48,
                                    width: 48,
                                    fit: BoxFit.cover,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: getEnhancedImage(
                                      currentSong
                                          .extras!['thumbnails']
                                          .first['url'],
                                      dp: MediaQuery.of(
                                        context,
                                      ).devicePixelRatio,
                                      width: 48,
                                    ),
                                    height: 48,
                                    width: 48,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Title + artist
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              currentSong.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.color,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            if (currentSong.artist != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                currentSong.artist!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.color,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Controls (Solid fill for play/pause in Apple style)
                      ValueListenableBuilder(
                        valueListenable: GetIt.I<MediaPlayer>().buttonState,
                        builder: (context, buttonState, child) {
                          return (buttonState == ButtonState.loading)
                              ? SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                )
                              : Hero(
                                  tag: 'playpause_${currentSong.id}',
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).iconTheme.color?.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          GetIt.I<MediaPlayer>().player.playing
                                              ? GetIt.I<MediaPlayer>().player
                                                    .pause()
                                              : GetIt.I<MediaPlayer>().player
                                                    .play();
                                        },
                                        icon: Icon(
                                          buttonState == ButtonState.playing
                                              ? CupertinoIcons.pause_fill
                                              : CupertinoIcons.play_fill,
                                          color: Theme.of(
                                            context,
                                          ).iconTheme.color,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                        },
                      ),
                      if (context.watch<MediaPlayer>().player.hasNext)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: IconButton(
                            onPressed: () {
                              GetIt.I<MediaPlayer>().player.seekToNext();
                            },
                            icon: Icon(
                              CupertinoIcons.forward_fill,
                              color: Theme.of(context).iconTheme.color,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Linear Progress Bar
                StreamBuilder<Duration>(
                  stream: GetIt.I<MediaPlayer>().player.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final duration =
                        GetIt.I<MediaPlayer>().player.duration ?? Duration.zero;
                    double progress = 0.0;
                    if (duration.inMilliseconds > 0) {
                      progress =
                          position.inMilliseconds / duration.inMilliseconds;
                    }
                    return LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      minHeight: 2,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).iconTheme.color ?? Colors.white,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
