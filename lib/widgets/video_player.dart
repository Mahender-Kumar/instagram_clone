import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  final VoidCallback onVideoEnd; // Callback to notify when video ends
  final String videoUrl;
  final bool isPaused; // Boolean to track if the video should be paused

  VideoApp({
    Key? key,
    required this.onVideoEnd,
    required this.videoUrl,
    required this.isPaused, // Receive pause state from parent
  }) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    )..initialize().then((_) {
        setState(() {});
        _controller.play(); // Start playing automatically
      });

    // Add listener for video completion
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        widget.onVideoEnd(); // Notify when the video has ended
      }
    });
  }

  @override
  void didUpdateWidget(VideoApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle pausing/resuming based on the isPaused state
    if (widget.isPaused) {
      _controller.pause();
    } else if (!_controller.value.isPlaying) {
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : Container(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
