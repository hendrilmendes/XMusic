import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:xmusic/CustomWidgets/gradient_containers.dart';
import 'package:xmusic/CustomWidgets/image_card.dart';
import 'package:xmusic/Helpers/config.dart';
import 'package:xmusic/Helpers/dominant_color.dart';
import 'package:xmusic/Screens/Player/audioplayer.dart';

class MiniPlayer extends StatefulWidget {
  static const MiniPlayer _instance = MiniPlayer._internal();

  factory MiniPlayer() {
    return _instance;
  }

  const MiniPlayer._internal();

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final AudioPlayerHandler audioHandler = GetIt.I<AudioPlayerHandler>();
  final ValueNotifier<List<Color?>?> gradientColor =
      ValueNotifier<List<Color?>?>(
    GetIt.I<MyTheme>().playGradientColor,
  );

  void updateBackgroundColors(List<Color?> value) {
    gradientColor.value = value;
    return;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final bool rotated = screenHeight < screenWidth;
    return SafeArea(
      top: false,
      child: StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, snapshot) {
          // if (snapshot.connectionState != ConnectionState.active) {
          //   return const SizedBox();
          // }
          final MediaItem? mediaItem = snapshot.data;
          // if (mediaItem == null) return const SizedBox();

          final List preferredMiniButtons = Hive.box('settings').get(
            'preferredMiniButtons',
            defaultValue: ['Like', 'Play/Pause', 'Next'],
          )?.toList() as List;

          final bool isLocal =
              mediaItem?.artUri?.toString().startsWith('file:') ?? false;

          final bool useDense = Hive.box('settings').get(
                'useDenseMini',
                defaultValue: false,
              ) as bool ||
              rotated;

          if (mediaItem != null) {
            if (mediaItem.artUri != null && mediaItem.artUri.toString() != '') {
              mediaItem.artUri.toString().startsWith('file')
                  ? getColors(
                      imageProvider: FileImage(
                        File(
                          mediaItem.artUri!.toFilePath(),
                        ),
                      ),
                    ).then((value) => updateBackgroundColors(value))
                  : getColors(
                      imageProvider: CachedNetworkImageProvider(
                        mediaItem.artUri.toString(),
                      ),
                    ).then((value) => updateBackgroundColors(value));
            }
          }

          return Dismissible(
            key: const Key('miniplayer'),
            direction: DismissDirection.vertical,
            confirmDismiss: (DismissDirection direction) {
              if (mediaItem != null) {
                if (direction == DismissDirection.down) {
                  audioHandler.stop();
                } else {
                  Navigator.pushNamed(context, '/player');
                }
              }
              return Future.value(false);
            },
            child: Dismissible(
              key: Key(mediaItem?.id ?? 'nothingPlaying'),
              confirmDismiss: (DismissDirection direction) {
                if (mediaItem != null) {
                  if (direction == DismissDirection.startToEnd) {
                    audioHandler.skipToPrevious();
                  } else {
                    audioHandler.skipToNext();
                  }
                }
                return Future.value(false);
              },
              child: ValueListenableBuilder(
                valueListenable: gradientColor,
                builder: (context, value, child) {
                  if (value == null) {
                    return GradientContainer(
                      borderRadius: true,
                      child: SizedBox(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            miniplayerTile(
                              context: context,
                              preferredMiniButtons: preferredMiniButtons,
                              useDense: useDense,
                              title: mediaItem?.title ?? '',
                              subtitle: mediaItem?.artist ?? '',
                              imagePath: (isLocal
                                      ? mediaItem?.artUri?.toFilePath()
                                      : mediaItem?.artUri?.toString()) ??
                                  '',
                              isLocalImage: isLocal,
                              isDummy: mediaItem == null,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: positionSlider(
                                mediaItem?.duration?.inSeconds.toDouble(),
                                null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    final Color miniplayerColor =
                        (value[0]?.computeLuminance() ?? 0) > 0.4
                            ? HSLColor.fromColor(value[0] ?? Colors.black)
                                .withLightness(0.4)
                                .toColor()
                            : value[0] ?? Colors.black;
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        color: miniplayerColor,
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 2.0,
                      ),
                      child: SizedBox(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            miniplayerTile(
                              context: context,
                              preferredMiniButtons: preferredMiniButtons,
                              useDense: useDense,
                              title: mediaItem?.title ?? '',
                              subtitle: mediaItem?.artist ?? '',
                              imagePath: (isLocal
                                      ? mediaItem?.artUri?.toFilePath()
                                      : mediaItem?.artUri?.toString()) ??
                                  '',
                              isLocalImage: isLocal,
                              isDummy: mediaItem == null,
                              buttonsColor: HSLColor.fromColor(miniplayerColor)
                                  .withLightness(0.9)
                                  .toColor(),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: positionSlider(
                                mediaItem?.duration?.inSeconds.toDouble(),
                                HSLColor.fromColor(miniplayerColor)
                                    .withLightness(0.9)
                                    .toColor(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  ListTile miniplayerTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String imagePath,
    required List preferredMiniButtons,
    bool useDense = false,
    bool isLocalImage = false,
    bool isDummy = false,
    Color? buttonsColor,
  }) {
    return ListTile(
      dense: useDense,
      onTap: isDummy
          ? null
          : () {
              Navigator.pushNamed(context, '/player');
            },
      title: Text(
        isDummy ? 'Now Playing' : title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 15,
          color: buttonsColor,
        ),
      ),
      subtitle: Text(
        isDummy ? 'Unknown' : subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 13,
          color: buttonsColor != null
              ? HSLColor.fromColor(buttonsColor).withLightness(0.85).toColor()
              : null,
        ),
      ),
      leading: Hero(
        tag: 'currentArtwork',
        child: imageCard(
          elevation: 8,
          boxDimension: useDense ? 44.0 : 50.0,
          localImage: isLocalImage,
          imageUrl: isLocalImage ? imagePath : imagePath,
        ),
      ),
      trailing: isDummy
          ? null
          : ControlButtons(
              audioHandler,
              miniplayer: true,
              buttons: isLocalImage
                  ? ['Like', 'Play/Pause', 'Next']
                  : preferredMiniButtons,
              buttonsColor: buttonsColor,
            ),
    );
  }

  StreamBuilder<Duration> positionSlider(double? maxDuration, Color? color) {
    return StreamBuilder<Duration>(
      stream: AudioService.position,
      builder: (context, snapshot) {
        final position = snapshot.data;
        return ((position?.inSeconds.toDouble() ?? 0) < 0.0 ||
                ((position?.inSeconds.toDouble() ?? 0) >
                    (maxDuration ?? 180.0)))
            ? const SizedBox()
            : SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: color ?? Colors.white,
                  inactiveTrackColor: Colors.transparent,
                  trackHeight: 0.5,
                  thumbColor: color ?? Colors.white,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 1.0,
                  ),
                  overlayColor: Colors.transparent,
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 2.0,
                  ),
                ),
                child: Center(
                  child: Slider(
                    inactiveColor: Colors.transparent,
                    // activeColor: Colors.white,
                    value: position?.inSeconds.toDouble() ?? 0,
                    max: maxDuration ?? 180.0,
                    onChanged: (newPosition) {
                      audioHandler.seek(
                        Duration(
                          seconds: newPosition.round(),
                        ),
                      );
                    },
                  ),
                ),
              );
      },
    );
  }
}
