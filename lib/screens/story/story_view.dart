import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone/models/story_model.dart';
import 'package:instagram_clone/screens/story/bar.dart';
import 'package:instagram_clone/screens/story/user_info.dart';
import 'package:instagram_clone/services.dart';
import 'package:video_player/video_player.dart';

class StoryFeedView extends ConsumerStatefulWidget {
  const StoryFeedView({
    Key? key,
    required this.stories,
    required this.herotagString,
    this.initialPage = 0,
  }) : super(key: key);

  final List<dynamic> stories;
  final String herotagString;
  final int? initialPage;
  @override
  _StoryFeedViewState createState() => _StoryFeedViewState();
}

class _StoryFeedViewState extends ConsumerState<StoryFeedView>
    with TickerProviderStateMixin {
  PageController? _pageController;
  PageController? _childpageController;
  AnimationController? _animationController;
  VideoPlayerController? _videoPlayerController;
  int _currentIndex = 0;
  final _pageNotifier = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage!);
    _childpageController = PageController();
    _animationController = AnimationController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageController!.addListener(_listener);
    });
    final Story firstStory = widget.stories.first;
    _loadStory(story: firstStory, animationToPage: false);
    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController!.stop();
        _animationController!.reset();
        setState(() {
          if (_currentIndex + 1 < widget.stories.length) {
            _currentIndex += 1;
            _loadStory(story: widget.stories[_currentIndex]);
          } else {
            _currentIndex = 0;
            _loadStory(story: widget.stories[_currentIndex]);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController!.removeListener(_listener);
    _pageController!.dispose();
    _childpageController!.dispose();
    _pageNotifier.dispose();
    _animationController!.dispose();
    super.dispose();
  }

  void _listener() {
    _pageNotifier.value = _pageController!.page!;
  }

  @override
  Widget build(BuildContext context) {
    final Story story = widget.stories[_currentIndex];

    var borderside = const BorderSide(
      color: Colors.white,
      width: 0.5,
    );
    var borderRadius = BorderRadius.circular(16);
    var outlineInput =
        OutlineInputBorder(borderSide: borderside, borderRadius: borderRadius);
    return Material(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: ref.watch(userProvider).when(
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
            error: (e, s) {
              return Center(
                child: Text('Error: $e'),
              );
            },
            data: (users) {
              return ValueListenableBuilder<double>(
                  valueListenable: _pageNotifier,
                  builder: (_, value, child) {
                    return PageView.builder(
                      controller: _pageController,
                      physics: const ClampingScrollPhysics(),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final isLeaving = (index - value) <= 0;
                        final t = (index - value);
                        final rotationY = lerpDouble(0, 90, t);
                        final opacity =
                            lerpDouble(0, 1, t.abs())!.clamp(0.0, 1.0);
                        final transform = Matrix4.identity();
                        transform.setEntry(3, 2, 0.003);
                        transform
                            .rotateY(double.parse('${-degToRad(rotationY!)}'));
                        return GestureDetector(
                          onTapDown: (details) => _onTapDown(details, story),
                          onVerticalDragUpdate: (details) =>
                              Navigator.of(context).pop(),
                          child: Transform(
                            alignment: isLeaving
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            transform: transform,
                            child: Stack(
                              children: [
                                Stack(
                                  children: [
                                    PageView.builder(
                                      controller: _childpageController,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: users[index].stories!.length,
                                      itemBuilder: (context, index) {
                                        final Story story =
                                            users[index].stories![index];
                                        print(
                                            'user herer${users[index].stories!.length}');
                                        print('user herer${story}');

                                        switch (story.media) {
                                          case MediaType.image:
                                            return CachedNetworkImage(
                                              imageUrl: story.url,
                                              fit: BoxFit.cover,
                                            );

                                          case MediaType.video:
                                            if (_videoPlayerController!
                                                .value.isInitialized) {
                                              return FittedBox(
                                                fit: BoxFit.cover,
                                                child: SizedBox(
                                                  width: _videoPlayerController!
                                                      .value.size.width,
                                                  height:
                                                      _videoPlayerController!
                                                          .value.size.height,
                                                  child: VideoPlayer(
                                                      _videoPlayerController!),
                                                ),
                                              );
                                            }
                                        }

                                        return Stack(
                                          alignment: Alignment.center,
                                          children: const [
                                            SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                    Positioned(
                                      top: 10.0,
                                      left: 10.0,
                                      right: 10.0,
                                      child: SafeArea(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: users[index]
                                                  .stories!
                                                  .asMap()
                                                  .map((key, value) {
                                                    return MapEntry(
                                                        key,
                                                        AnimatedBar(
                                                            animationController:
                                                                _animationController!,
                                                            position: key,
                                                            currentindex:
                                                                _currentIndex));
                                                  })
                                                  .values
                                                  .toList(),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1.5,
                                                      vertical: 10.0),
                                              child: Hero(
                                                  tag: widget.herotagString,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: UserInfo(
                                                          user: users[index],
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 10,
                                        child: SafeArea(
                                            child: Row(
                                          children: [
                                            SizedBox(
                                              width: 12,
                                              // width: 10.w,
                                            ),
                                            GestureDetector(
                                              child: Container(
                                                padding: EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                    )),
                                                child: Icon(
                                                  Icons.camera_alt_rounded,
                                                  color: Colors.white,
                                                  // size: 20.w,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12,
                                              // width: 10.w,
                                            ),
                                            Expanded(
                                              child: TextField(
                                                // style: textsize12.copyWith(
                                                //     color: Colors.white),
                                                cursorColor: Colors.white,
                                                decoration: InputDecoration(
                                                    errorBorder: outlineInput,
                                                    hintText: 'Send Message',
                                                    // hintStyle: textsize12.copyWith(
                                                    //     color: Colors.white),
                                                    disabledBorder: outlineInput.copyWith(
                                                        borderSide:
                                                            borderside.copyWith(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300)),
                                                    focusedBorder: outlineInput,
                                                    enabledBorder:
                                                        outlineInput.copyWith(
                                                            borderSide: borderside
                                                                .copyWith(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300)),
                                                    border: outlineInput,
                                                    isDense: true,
                                                    suffixIconConstraints:
                                                        BoxConstraints(
                                                            // maxHeight: 20.w,
                                                            // maxWidth: 20.w
                                                            ),
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            12, 12, 12, 12
                                                            // 10.w, 6.w, 6.w, 5.w
                                                            ),
                                                    suffixIcon: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                // right: 6.w
                                                                ),
                                                        child: Icon(
                                                          Icons
                                                              .more_vert_rounded,
                                                          color: Colors.white,
                                                          // size: 10.w,
                                                        ))),
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: null,
                                                icon: FaIcon(
                                                  FontAwesomeIcons
                                                      .solidPaperPlane,
                                                  color: Colors.white,
                                                  size: 16,
                                                ))
                                          ],
                                        )))
                                  ],
                                ),
                                Positioned.fill(
                                    child: Opacity(
                                        opacity: opacity,
                                        child: Container(
                                          color: Colors.black87,
                                        )))
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  });
            }),
      ),
    );
  }

  void _onTapDown(TapDownDetails detalis, Story story) {
    final double screenwidth = MediaQuery.of(context).size.width;
    final double dx = detalis.globalPosition.dx;
    if (dx < screenwidth / 3) {
      setState(() {
        if (_currentIndex - 1 >= 0) {
          _currentIndex -= 1;
          _loadStory(story: widget.stories[_currentIndex]);
        }
      });
    } else if (dx > 2 * screenwidth / 3) {
      setState(() {
        if (_currentIndex + 1 < widget.stories.length) {
          _currentIndex += 1;
          _loadStory(story: widget.stories[_currentIndex]);
        } else {
          _currentIndex = 0;
          _loadStory(story: widget.stories[_currentIndex]);
        }
      });
    } else {
      if (story.media == MediaType.video) {
        if (_videoPlayerController!.value.isPlaying) {
          _videoPlayerController!.pause();
          _animationController!.stop();
        } else {
          _videoPlayerController!.play();
          _animationController!.forward();
        }
      }
    }
  }

  void _loadStory({required Story story, bool animationToPage = true}) {
    _animationController!.stop();
    _animationController!.reset();
    switch (story.media) {
      case MediaType.image:
        print('2object${story.media}this');
        _animationController!.duration = story.duration;
        _animationController!.forward();
        break;
      case MediaType.video:
        print('2object${story.media}');
        print('2object${story.url}');
        print('2object${story.storyId}');
        print('2object${story.timestamp}');
        _videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(story.url))
              ..initialize().then((value) {
                print('2object${story.url}');
                setState(() {});
                if (_videoPlayerController!.value.isInitialized) {
                  _animationController!.duration =
                      _videoPlayerController!.value.duration;

                  _videoPlayerController!.addListener(() {
                    if (_videoPlayerController!.value.position >=
                        _videoPlayerController!.value.duration) {
                      // Move to the next story when the video ends
                      // Reset the animation controller
                      _animationController!.stop();
                      _animationController!.reset();

                      // Move to the next story if available, otherwise reset to the first story
                      setState(() {
                        if (_currentIndex + 1 < widget.stories.length) {
                          _currentIndex += 1;
                          _loadStory(story: widget.stories[_currentIndex]);
                        } else {
                          _currentIndex = 0;
                          _loadStory(story: widget.stories[_currentIndex]);
                        }
                      });
                    }
                    // If the video is playing, continue the animation
                    if (_videoPlayerController!.value.isPlaying) {
                      _animationController!.forward();
                    } else {
                      // If the video is paused or buffering, stop the animation
                      _animationController!.stop();
                    }
                  });
                  _videoPlayerController!.play();
                  _animationController!.forward();
                }
              });
        break;
      default:
    }
    if (animationToPage) {
      _childpageController!.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }
}

num degToRad(num deg) => deg * (pi / 180.0);
num radToDeg(num deg) => deg * (180.0 / pi);
