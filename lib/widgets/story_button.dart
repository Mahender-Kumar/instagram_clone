import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instagram_clone/models/story.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/widgets/video_player.dart';
import 'package:provider/provider.dart';

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
                child: CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage(
                    user.profilePicture,
                  ),
                ),
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
    super.key,
    required this.stories,
    required this.initialIndex,
  });

  @override
  _StoryDetailPageState createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  late PageController _pageController;
  late int _currentIndex;
  late double _progress; // Variable to track progress
  Timer? _progressTimer; // Timer for progress
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
    _startProgressTimer(); // Start the timer for progress
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressTimer?.cancel(); // Cancel the timer
    super.dispose();
  }

  void _startProgressTimer() {
    _progressTimer?.cancel(); // Cancel any existing timer
    _progress = 0.0; // Reset progress
    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_isPaused) {
        setState(() {
          _progress += 0.01; // Increment progress
        });
        if (_progress >= 1.0) {
          _onVideoEnd(); // Go to next story when progress is complete
        }
      }
    });
  }

  void _resetProgress() {
    _progress = 0.0; // Reset progress
    _startProgressTimer(); // Restart timer for new story
  }

  void _onTapLeft() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onTapRight() {
    if (_currentIndex < widget.stories.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onVideoEnd() {
    if (_currentIndex < widget.stories.length - 1) {
      _onTapRight();
    }
  }

  // Pause progress and video on hold
  void _onHold() {
    setState(() {
      _isPaused = true; // Pause the linear progress
    });
    // TODO: Implement pausing video logic if using a video player.
  }

  // Resume progress and video on release
  void _onRelease() {
    setState(() {
      _isPaused = false; // Resume linear progress
    });
    // TODO: Implement resuming video logic if using a video player.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onHorizontalDragEnd: (details) {
              if (!_isPaused) {
                if (details.velocity.pixelsPerSecond.dx < 0) {
                  _onTapRight();
                } else {
                  _onTapLeft();
                }
              }
            },
            onLongPressStart: (_) => _onHold(), // Pause on hold
            onLongPressEnd: (_) => _onRelease(), // Resume on release
            child: PageView.builder(
              itemCount: widget.stories.length,
              controller: _pageController,
              itemBuilder: (context, index) {
                final story = widget.stories[index];
                return story.mediaType == 'image'
                    ? Center(
                        child: Hero(
                          tag: story.mediaUrl,
                          child: Image.network(
                            story.mediaUrl,
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    : VideoApp(
                        onVideoEnd: _onVideoEnd,
                        videoUrl: story.mediaUrl,
                        isPaused: _isPaused, // Pass pause state to VideoApp
                      );
              },
            ),
          ),
          Consumer(builder: (context, ref, child) {
            return Positioned(
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
                          // Circular Indicator
                          Container(
                            decoration: BoxDecoration(
                              color: _currentIndex <= index
                                  ? Colors.grey
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          // Linear Progress Indicator
                          if (_currentIndex == index)
                            LinearProgressIndicator(
                              value: _progress,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white), // Change to desired color
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
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
