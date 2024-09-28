import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/story.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/widgets/story/components/stories_list_skeleton.dart';
import 'package:instagram_clone/widgets/story/story_image.dart';
import 'package:instagram_clone/widgets/video_player.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class StoryButton extends StatelessWidget {
  User user;

  String tag;

  StoryButton({super.key, required this.user, required this.tag});

  void _onStoryTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryDetailPage(
          stories: [
            ...user.stories,
          ],
          initialIndex: 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            _onStoryTap(context);
          },
          splashColor: Colors.transparent,
          child: Hero(
            tag: tag,
            child: Container(
              padding: const EdgeInsets.all(
                  2.0), // Padding to create a gap between the border and the avatar
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.pink, Colors.orange, Colors.yellow],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                  padding:
                      const EdgeInsets.all(2.0), // Gap between border and image
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black, // Background color for the gap
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: user.profilePicture,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => StoriesListSkeletonAlone(
                        width: 72,
                        height: 72,
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error, size: 72),
                    ),
                  )
                  // CircleAvatar(
                  //   radius: 36,
                  //   backgroundImage: NetworkImage(
                  //     user.profilePicture,
                  //   ),
                  // ),
                  ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user.userName,
          style: TextStyle(
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class StoryDetailPage extends StatefulWidget {
  final List<Story> stories;
  final int initialIndex;

  const StoryDetailPage({
    Key? key,
    required this.stories,
    required this.initialIndex,
  }) : super(key: key);

  @override
  _StoryDetailPageState createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  late PageController _pageController;
  late int _currentIndex;
  late double _progress; // Variable to track progress
  bool _isPaused = false; // To track whether progress is paused

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _progress = 0.0; // Initialize progress
    _pageController = PageController(initialPage: _currentIndex);
    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page!.round(); // Update current index
        _resetProgress(); // Reset progress when changing stories
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _resetProgress() {
    setState(() {
      _progress = 0.0; // Reset progress
    });
  }

  void _onVideoEnd() {
    if (_currentIndex < widget.stories.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _updateProgress(VideoPlayerController controller) {
    if (controller.value.isInitialized) {
      double progress = controller.value.position.inSeconds.toDouble() /
          controller.value.duration.inSeconds.toDouble();
      setState(() {
        _progress =
            progress.clamp(0.0, 1.0); // Ensure progress is between 0 and 1
      });
    }
  }

  void _onHold() {
    setState(() {
      _isPaused = true; // Pause the linear progress
    });
  }

  void _onRelease() {
    setState(() {
      _isPaused = false; // Resume linear progress
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTapDown: (TapDownDetails details) {
              double tapX = details.globalPosition.dx;
              double screenWidth = MediaQuery.of(context).size.width;

              if (tapX < screenWidth / 2) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            onLongPressStart: (_) => _onHold(), // Pause on hold
            onLongPressEnd: (_) => _onRelease(), // Resume on release
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.stories.length,
              controller: _pageController,
              itemBuilder: (context, index) {
                final story = widget.stories[index];
                final ImageLoader imageLoader = ImageLoader(story.mediaUrl);
                return story.mediaType == 'image'
                    ? Center(
                        child: Hero(
                            tag: story.mediaUrl, child: StoryImage(imageLoader)
                            // Image.network(
                            //   story.mediaUrl,
                            //   fit: BoxFit.fill,
                            // ),
                            ),
                      )
                    : VideoApp(
                        onVideoEnd: _onVideoEnd,
                        videoUrl: story.mediaUrl,
                        isPaused: _isPaused,
                        onProgressUpdate: (controller) =>
                            _updateProgress(controller),
                      );
              },
            ),
          ),
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.stories.length, (index) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    height: 2.0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: _currentIndex > index
                                ? Colors.white
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        if (_currentIndex == index)
                          LinearProgressIndicator(
                            value: _progress,
                            backgroundColor: Colors.transparent,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class TitleListTile extends StatelessWidget {
  const TitleListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 36,
        backgroundImage: NetworkImage(
          'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
        ),
      ),
      title: const Text('Stories'),
      trailing: const Icon(Icons.arrow_forward),
    );
  }
}
