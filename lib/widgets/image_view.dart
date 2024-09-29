import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:instagram_clone/models/story.dart';

class ImageView extends StatelessWidget {
  ImageView({
    super.key,
    required this.story,
  });

  final Story story;

  final cacheMnager = CacheManager(
    Config(
      'video_cache',
      stalePeriod: const Duration(days: 2),
      maxNrOfCacheObjects: 20,
      repo: JsonCacheInfoRepository(databaseName: 'video_cache'),
      fileService: HttpFileService(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: story.mediaUrl,
      fit: BoxFit.fill,
      filterQuality: FilterQuality.high,
      // Optionally provide a placeholder while the image is loading
      // placeholder: (context, url) => const Center(
      //   child: CircularProgressIndicator(),
      // ),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      // Use AnimatedOpacity to create a fade-in effect
      imageBuilder: (context, imageProvider) {
        return AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
      cacheManager: DefaultCacheManager(),
      // Error widget if the image fails to load
      errorWidget: (context, url, error) {
        return const Icon(Icons.error);
      },
    );
  }
}
