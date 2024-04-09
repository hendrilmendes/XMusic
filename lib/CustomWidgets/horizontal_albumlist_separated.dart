
import 'package:flutter/material.dart';
import 'package:xmusic/CustomWidgets/custom_physics.dart';
import 'package:xmusic/CustomWidgets/image_card.dart';
import 'package:xmusic/CustomWidgets/song_tile_trailing_menu.dart';

class HorizontalAlbumsListSeparated extends StatelessWidget {
  final List songsList;
  final Function(int) onTap;
  const HorizontalAlbumsListSeparated({
    super.key,
    required this.songsList,
    required this.onTap,
  });

  String formatString(String? text) {
    return text == null
        ? ''
        : text
            .replaceAll('&amp;', '&')
            .replaceAll('&#039;', "'")
            .replaceAll('&quot;', '"')
            .trim();
  }

  String getSubTitle(Map item) {
    final type = item['type'];
    if (type == 'charts') {
      return '';
    } else if (type == 'playlist' || type == 'radio_station') {
      return formatString(item['subtitle']?.toString());
    } else if (type == 'song') {
      return formatString(item['artist']?.toString());
    } else {
      if (item['subtitle'] != null) {
        return formatString(item['subtitle']?.toString());
      }
      final artists = item['more_info']?['artistMap']?['artists']
          .map((artist) => artist['name'])
          .toList();
      if (artists != null) {
        return formatString(artists?.join(', ')?.toString());
      }
      if (item['artist'] != null) {
        return formatString(item['artist']?.toString());
      }
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool rotated =
        MediaQuery.sizeOf(context).height < MediaQuery.sizeOf(context).width;
    final bool biggerScreen = MediaQuery.sizeOf(context).width > 1050;
    final double portion = (songsList.length <= 4) ? 1.0 : 0.875;
    final double listSize = rotated
        ? biggerScreen
            ? MediaQuery.sizeOf(context).width * portion / 3
            : MediaQuery.sizeOf(context).width * portion / 2
        : MediaQuery.sizeOf(context).width * portion;
    return SizedBox(
      height: songsList.length < 4 ? songsList.length * 74 : 74 * 4,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ListView.builder(
          physics: PagingScrollPhysics(itemDimension: listSize),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemExtent: listSize,
          itemCount: (songsList.length / 4).ceil(),
          itemBuilder: (context, index) {
            final itemGroup = songsList.skip(index * 4).take(4);
            return SizedBox(
              height: 72 * 4,
              width: listSize,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: itemGroup.map((item) {
                  final subTitle = getSubTitle(item as Map);
                  return ListTile(
                    title: Text(
                      formatString(item['title']?.toString()),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      subTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: imageCard(
                      imageUrl: item['image'].toString(),
                      placeholderImage: (item['type'] == 'playlist' ||
                              item['type'] == 'album')
                          ? const AssetImage(
                              'assets/album.png',
                            )
                          : item['type'] == 'artist'
                              ? const AssetImage(
                                  'assets/artist.png',
                                )
                              : const AssetImage(
                                  'assets/cover.jpg',
                                ),
                    ),
                    trailing: SongTileTrailingMenu(
                      data: item,
                    ),
                    onTap: () => onTap(songsList.indexOf(item)),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
