import 'package:audio_service/audio_service.dart';
import 'package:xmusic/Models/song_item.dart';
import 'package:xmusic/Models/url_image_generator.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// ignore: avoid_classes_with_only_static_members
class MediaItemConverter {
  static Map mediaItemToMap(MediaItem mediaItem) {
    return {
      'id': mediaItem.id,
      'album': mediaItem.album.toString(),
      'album_id': mediaItem.extras?['album_id'],
      'artist': mediaItem.artist.toString(),
      'duration': mediaItem.duration?.inSeconds.toString(),
      'genre': mediaItem.genre.toString(),
      'has_lyrics': mediaItem.extras!['has_lyrics'],
      'image': mediaItem.artUri.toString(),
      'language': mediaItem.extras?['language'].toString(),
      'release_date': mediaItem.extras?['release_date'],
      'subtitle': mediaItem.extras?['subtitle'],
      'title': mediaItem.title,
      'url': mediaItem.extras!['url'].toString(),
      'allUrls': mediaItem.extras!['allUrls'],
      'year': mediaItem.extras?['year'].toString(),
      '320kbps': mediaItem.extras?['320kbps'],
      'quality': mediaItem.extras?['quality'],
      'perma_url': mediaItem.extras?['perma_url'],
      'expire_at': mediaItem.extras?['expire_at'],
    };
  }

  static MediaItem mapToMediaItem(
    Map song, {
    bool addedByAutoplay = false,
    bool autoplay = true,
    String? playlistBox,
  }) {
    return MediaItem(
      id: song['id'].toString(),
      album: song['album'].toString(),
      artist: song['artist'].toString(),
      duration: Duration(
        seconds: int.parse(
          (song['duration'] == null ||
                  song['duration'] == 'null' ||
                  song['duration'] == '')
              ? '180'
              : song['duration'].toString(),
        ),
      ),
      title: song['title'].toString(),
      artUri: Uri.parse(UrlImageGetter([song['image'].toString()]).highQuality),
      genre: song['language'].toString(),
      extras: {
        'url': song['url'],
        'allUrls': song['allUrls'],
        'year': song['year'],
        'language': song['language'],
        '320kbps': song['320kbps'],
        'quality': song['quality'],
        'has_lyrics': song['has_lyrics'],
        'release_date': song['release_date'],
        'album_id': song['album_id'],
        'subtitle': song['subtitle'],
        'perma_url': song['perma_url'],
        'expire_at': song['expire_at'],
        'addedByAutoplay': addedByAutoplay,
        'autoplay': autoplay,
        'playlistBox': playlistBox,
      },
    );
  }

  static MediaItem downMapToMediaItem(Map song) {
    return MediaItem(
      id: song['id'].toString(),
      album: song['album'].toString(),
      artist: song['artist'].toString(),
      duration: Duration(
        seconds: int.parse(
          (song['duration'] == null ||
                  song['duration'] == 'null' ||
                  song['duration'] == '')
              ? '180'
              : song['duration'].toString(),
        ),
      ),
      title: song['title'].toString(),
      artUri: Uri.file(song['image'].toString()),
      genre: song['genre'].toString(),
      extras: {
        'url': song['path'].toString(),
        'year': song['year'],
        'language': song['genre'],
        'release_date': song['release_date'],
        'album_id': song['album_id'],
        'subtitle': song['subtitle'],
        'quality': song['quality'],
      },
    );
  }

  static MediaItem songItemToMediaItem({
    required SongItem songItem,
    bool addedByAutoplay = false,
    bool autoplay = true,
    String? playlistBox,
  }) {
    return MediaItem(
      id: songItem.id,
      album: songItem.album,
      artist: songItem.artists.join(', '),
      duration: songItem.duration,
      title: songItem.title,
      artUri: Uri.parse(UrlImageGetter([songItem.image]).highQuality),
      genre: songItem.genre,
      extras: {
        'url': songItem.url,
        'allUrls': songItem.allUrls,
        'year': songItem.year,
        'language': songItem.language,
        '320kbps': songItem.kbps320,
        'quality': songItem.quality,
        'has_lyrics': songItem.hasLyrics,
        'release_date': songItem.releaseDate,
        'album_id': songItem.albumId,
        'subtitle': songItem.subtitle,
        'perma_url': songItem.permaUrl,
        'expire_at': songItem.expireAt,
        'addedByAutoplay': addedByAutoplay,
        'autoplay': autoplay,
        'playlistBox': playlistBox,
      },
    );
  }

  static Map<String, dynamic> videoToMap(Video video) {
    return {
      'id': video.id.value,
      'album': video.author.replaceAll('- Topic', '').trim(),
      'duration': video.duration?.inSeconds ?? 180,
      'title': video.title.trim(),
      'artist': video.author.replaceAll('- Topic', '').trim(),
      'image': video.thumbnails.highResUrl,
      'language': 'YouTube',
      'genre': 'YouTube',
      'year': video.uploadDate?.year,
      '320kbps': false,
      'has_lyrics': false,
      'release_date': video.publishDate.toString(),
      'album_id': video.channelId.value,
      'subtitle': video.author,
      'perma_url': video.url,
    };
  }
}
