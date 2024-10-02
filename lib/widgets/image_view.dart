import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:instagram_clone/models/story_model.dart';

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
    print('inside image view');
    return CachedNetworkImage(
      imageUrl: story.url,
      fit: BoxFit.fill,
      filterQuality: FilterQuality.high,
      // Optionally provide a placeholder while the image is loading
      // placeholder: (context, url) => const Center(
      //   child: CircularProgressIndicator(),
      // ),
      progressIndicatorBuilder: (context, url, downloadProgress) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            value: downloadProgress.progress,
            color: Colors.white,
          ),
        ],
      ),
      // Use AnimatedOpacity to create a fade-in effect
      imageBuilder: (context, imageProvider) {
        print('inside image view builder');
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
        print('inside image view error');
        return const Icon(Icons.error);
      },
    );
  }
}
