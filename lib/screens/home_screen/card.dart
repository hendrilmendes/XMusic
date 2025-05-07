import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class HighlightCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final String? videoId;
  final VoidCallback onTap;

  static final CacheManager _cacheManager = CacheManager(
    Config(
      'highlightCardCache',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: 'highlight_card'),
      fileService: HttpFileService(),
    ),
  );

  const HighlightCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.videoId,
    required this.onTap,
  });

  String _highResThumbnail(String? url, String? videoId) {
    if (url != null && url.contains('hqdefault')) {
      return url.replaceAll('hqdefault', 'maxresdefault');
    }
    if (videoId != null && videoId.isNotEmpty) {
      return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
    }
    return url ?? '';
  }

  Widget _buildImage() {
    final rawUrl = (imageUrl ?? '').trim();
    if (rawUrl.isEmpty) {
      return Container(color: Colors.grey[800]);
    }

    final url = _highResThumbnail(rawUrl, videoId);

    return CachedNetworkImage(
      imageUrl: url,
      cacheManager: _cacheManager,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      placeholder:
          (context, url) => Container(
            color: Colors.grey[800],
            child: const Center(child: CircularProgressIndicator()),
          ),
      errorWidget:
          (context, url, error) => Container(
            color: Colors.grey[800],
            child: const Icon(Icons.error_outline, color: Colors.white),
          ),
      imageBuilder:
          (context, imageProvider) => Image(
            image: imageProvider,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
      memCacheWidth: 1280,
      memCacheHeight: 720,
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.9), Colors.transparent],
          stops: const [0.0, 0.6],
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
          ),
          if (subtitle.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              _buildImage(),
              _buildGradientOverlay(),
              _buildTextContent(),
            ],
          ),
        ),
      ),
    );
  }
}
