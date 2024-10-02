// import 'dart:math';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:instagram_clone/models/story_model.dart';
// import 'package:instagram_clone/screens/story/bar.dart';
// import 'package:instagram_clone/screens/story/user_info.dart';
// import 'package:instagram_clone/services.dart';
// import 'package:instagram_clone/widgets/image_view.dart';
// import 'package:video_player/video_player.dart';

// class StoryFeedView extends ConsumerStatefulWidget {
//   const StoryFeedView({
//     Key? key,
//     this.initialPage = 0,
//   }) : super(key: key);

//   final int initialPage;

//   @override
//   _StoryFeedViewState createState() => _StoryFeedViewState();
// }

// class _StoryFeedViewState extends ConsumerState<StoryFeedView>
//     with TickerProviderStateMixin {
//   Key _key = UniqueKey();

//   PageController? _pageController = PageController(initialPage: 0);
//   PageController? _childpageController;
//   AnimationController? _animationController;
//   VideoPlayerController? _videoPlayerController;
//   int _currentIndex = 0; 

//   // @override
//   // void didChangeDependencies() {
//   //   super.didChangeDependencies();
//   //   if (_pageController == null ||
//   //       _pageController!.initialPage != widget.initialPage) {
//   //     _pageController = PageController(initialPage: widget.initialPage);
//   //     _pageController!.addListener(() { 
//   //       setState(() {
//   //         currentPageValue = _pageController!.page;
//   //       });
//   //     });
//   //     _loadInitialStory();
//   //   }
//   // }

//   var currentPageValue;
//   @override
//   void initState() {
//     super.initState();
//     print('initState');
//     _pageController = PageController(initialPage: widget.initialPage);
//     currentPageValue = widget.initialPage.toDouble();
//     _childpageController = PageController(initialPage: 0);
//     _animationController = AnimationController(vsync: this);
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _pageController!.addListener(() { 
//         setState(() {
//           currentPageValue = _pageController!.page;
//         });
//       });
//     });
//     _loadInitialStory();
//     _animationController!.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _animationController!.stop();
//         _animationController!.reset();
//         setState(() {
//           if (_currentIndex + 1 <
//               ref
//                   .read(userProvider)
//                   .value![widget.initialPage!]
//                   .stories!
//                   .length) {
//             _currentIndex += 1;
//             _loadStory(
//                 story: ref
//                     .read(userProvider)
//                     .value![widget.initialPage!]
//                     .stories![_currentIndex],
//                 stories: ref
//                     .read(userProvider)
//                     .value![widget.initialPage!]
//                     .stories!);
//           } else {
//             _currentIndex = 0;
//             _loadStory(
//                 story: ref
//                     .read(userProvider)
//                     .value![widget.initialPage!]
//                     .stories![_currentIndex],
//                 stories: ref
//                     .read(userProvider)
//                     .value![widget.initialPage!]
//                     .stories!);
//           }
//         });
//       }
//     });
//   }

//   void _loadInitialStory() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final users = ref.read(userProvider).value;
//       if (users != null && users.isNotEmpty) {
//         _loadStory(
//             animationToPage: false,
//             story: users[widget.initialPage].stories![0],
//             stories: users[widget.initialPage].stories!);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _videoPlayerController?.dispose();
//     _pageController!.removeListener(_listener);
//     _pageController!.dispose();
//     _childpageController!.dispose();
 
//     _animationController!.dispose();
//     super.dispose();
//   }

//   void _listener() {}

//   void _forceRedraw() {
//     setState(() {
//       _key = UniqueKey();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final Story story = ref.read(userProvider).value!.stories![_currentIndex];

//     var borderside = const BorderSide(
//       color: Colors.white,
//       width: 0.5,
//     );
//     var borderRadius = BorderRadius.circular(16);
//     var outlineInput =
//         OutlineInputBorder(borderSide: borderside, borderRadius: borderRadius);
//     return Material(
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: ref.watch(userProvider).when(
//             loading: () => const Center(
//                   child: CircularProgressIndicator(),
//                 ),
//             error: (e, s) {
//               print('error: $e');
//               return Center(
//                 child: Text('Error: $e',
//                     style: const TextStyle(fontSize: 24, color: Colors.white)),
//               );
//             },
//             data: (users) {
//               return Center(
//                       child: PageView.builder(
//                         key: _key,
//                         controller: _pageController,
//                         //  _pageController?.initialPage == 0
//                         //     ? _pageController
//                         //     : PageController(
//                         //         initialPage: widget.initialPage,
//                         //       ),
//                         physics: const ClampingScrollPhysics(),
//                         itemCount: users.length,
//                         onPageChanged: (index) {
//                           // _currentIndex = index;
//                           _currentIndex = 0;

//                           _loadStory(
//                               story: users[index].stories![_currentIndex],
//                               // story: users[index].stories![index],
//                               stories: users[index].stories!);
//                           _forceRedraw();
//                         },
//                         itemBuilder: (context, index) {
//                           final isLeaving = (index - currentPageValue) <= 0;
//                           final t = (index - currentPageValue);
//                           final rotationY = lerpDouble(0, 90, t as double);
//                           final opacity =
//                               lerpDouble(0, 1, t.abs())!.clamp(0.0, 1.0);
//                           final transform = Matrix4.identity();
//                           transform.setEntry(3, 2, 0.003);
//                           transform.rotateY(
//                               double.parse('${-degToRad(rotationY!)}'));
//                           // _currentIndex = 0;
//                           return GestureDetector(
//                             onTapDown: (details)
//                                 // {
//                                 //   // Check if we're not on the first page
//                                 //   print(_pageController!.page! > 0);
//                                 //   print(details.localPosition.dx < 50);
//                                 //   print(_childpageController!.page!.toInt() == 0);
//                                 //   if (_pageController!.page! > 0 &&
//                                 //       details.localPosition.dx < 50 &&
//                                 //       _childpageController!.page!.toInt() == 0) {
//                                 //     _pageController!.animateToPage(
//                                 //       _pageController!.page!.toInt() -
//                                 //           1, // Go to the previous page
//                                 //       duration: const Duration(
//                                 //           milliseconds:
//                                 //               300), // Adjust duration for smooth animation
//                                 //       curve: Curves
//                                 //           .easeInOut, // Use the same curve for smooth transition
//                                 //     );
//                                 //   }
//                                 // },

//                                 =>
//                                 _onTapDown(details, users[index].stories![0],
//                                     users[index].stories!),
//                             onVerticalDragUpdate: (details) =>
//                                 Navigator.of(context).pop(),
//                             child: Transform(
//                               alignment: isLeaving
//                                   ? Alignment.centerRight
//                                   : Alignment.centerLeft,
//                               transform: transform,
//                               child: Stack(
//                                 children: [
//                                   Stack(
//                                     children: [
//                                       PageView.builder(
//                                         controller: _childpageController,
//                                         physics:
//                                             const NeverScrollableScrollPhysics(),
//                                         itemCount: users[index].stories!.length,
//                                         itemBuilder: (context, index2) {
//                                           print('index = ${index}');
//                                           print('index2 = ${index2}');
//                                           print(
//                                               '_currentIndex = ${_currentIndex}');
//                                           final Story story =
//                                               users[index].stories![index2];
//                                           print(
//                                               'rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
//                                           print(story.url);
//                                           // _loadStory(
//                                           //     story: story,
//                                           //     stories: users[index].stories!);

//                                           switch (story.media) {
//                                             case MediaType.image:
//                                               print('inside image');
//                                               return ImageView(
//                                                 story: story,
//                                               );
//                                             // CachedNetworkImage(
//                                             //   imageUrl: story.url,
//                                             //   fit: BoxFit.cover,
//                                             // );

//                                             case MediaType.video:
//                                               print(
//                                                   'video contorller cllick second');
//                                               if (_videoPlayerController !=
//                                                       null &&
//                                                   _videoPlayerController!
//                                                       .value.isInitialized) {
//                                                 print(
//                                                     'inside video contorller cllick second');
//                                                 return FittedBox(
//                                                   fit: BoxFit.cover,
//                                                   child: SizedBox(
//                                                     width:
//                                                         _videoPlayerController!
//                                                             .value.size.width,
//                                                     height:
//                                                         _videoPlayerController!
//                                                             .value.size.height,
//                                                     child: VideoPlayer(
//                                                         _videoPlayerController!),
//                                                   ),
//                                                 );
//                                               }
//                                             // else {
//                                             //   print('inside else');
//                                             //   return Text('data');
//                                             // }
//                                           }

//                                           return const Stack(
//                                             alignment: Alignment.center,
//                                             children: [
//                                               SizedBox(
//                                                 height: 50,
//                                                 width: 50,
//                                                 child:
//                                                     CircularProgressIndicator(
//                                                   color: Colors.white,
//                                                   strokeWidth: 2,
//                                                 ),
//                                               )
//                                             ],
//                                           );
//                                         },
//                                       ),
//                                       Positioned(
//                                         top: 10.0,
//                                         left: 10.0,
//                                         right: 10.0,
//                                         child: SafeArea(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: <Widget>[
//                                               Row(
//                                                 children: users[index]
//                                                     .stories!
//                                                     .asMap()
//                                                     .map((key, value) {
//                                                       return MapEntry(
//                                                           key,
//                                                           AnimatedBar(
//                                                               animationController:
//                                                                   _animationController!,
//                                                               position: key,
//                                                               currentindex:
//                                                                   _currentIndex));
//                                                     })
//                                                     .values
//                                                     .toList(),
//                                               ),
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 1.5,
//                                                         vertical: 10.0),
//                                                 child: Hero(
//                                                     tag:
//                                                         '${users[index].userId}',
//                                                     child: Row(
//                                                       children: [
//                                                         Expanded(
//                                                           child: UserInfo(
//                                                             user: users[index],
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     )),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       Positioned(
//                                           left: 0,
//                                           right: 0,
//                                           bottom: 10,
//                                           child: SafeArea(
//                                               child: Row(
//                                             children: [
//                                               const SizedBox(
//                                                 width: 12,
//                                               ),
//                                               GestureDetector(
//                                                 child: Container(
//                                                   padding:
//                                                       const EdgeInsets.all(12),
//                                                   decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               16),
//                                                       border: Border.all(
//                                                         color: Colors
//                                                             .grey.shade300,
//                                                       )),
//                                                   child: const Icon(
//                                                     Icons.camera_alt_rounded,
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 width: 12,
//                                               ),
//                                               Expanded(
//                                                 child: TextField(
//                                                   cursorColor: Colors.white,
//                                                   decoration: InputDecoration(
//                                                       errorBorder: outlineInput,
//                                                       hintText: 'Send Message',
//                                                       disabledBorder: outlineInput.copyWith(
//                                                           borderSide: borderside
//                                                               .copyWith(
//                                                                   color: Colors
//                                                                       .grey
//                                                                       .shade300)),
//                                                       focusedBorder:
//                                                           outlineInput,
//                                                       enabledBorder:
//                                                           outlineInput.copyWith(
//                                                               borderSide: borderside.copyWith(
//                                                                   color: Colors
//                                                                       .grey
//                                                                       .shade300)),
//                                                       border: outlineInput,
//                                                       isDense: true,
//                                                       suffixIconConstraints:
//                                                           const BoxConstraints(),
//                                                       contentPadding:
//                                                           const EdgeInsets
//                                                               .fromLTRB(
//                                                               12, 12, 12, 12),
//                                                       suffixIcon: const Padding(
//                                                           padding:
//                                                               EdgeInsets.only(),
//                                                           child: Icon(
//                                                             Icons
//                                                                 .more_vert_rounded,
//                                                             color: Colors.white,
//                                                           ))),
//                                                 ),
//                                               ),
//                                               const IconButton(
//                                                   onPressed: null,
//                                                   icon: FaIcon(
//                                                     FontAwesomeIcons
//                                                         .solidPaperPlane,
//                                                     color: Colors.white,
//                                                     size: 16,
//                                                   ))
//                                             ],
//                                           )))
//                                     ],
//                                   ),
//                                   Positioned.fill(
//                                       child: Opacity(
//                                           opacity: opacity,
//                                           child: Container(
//                                             color: Colors.black,
//                                           )))
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//             }),
//       ),
//     );
//   }

//   void _onTapDown(TapDownDetails details, Story story, List<Story> stories) {
//     final double screenwidth = MediaQuery.of(context).size.width;
//     final double dx = details.globalPosition.dx;
//     // print(dx);

//     // Check if we're not on the first page
//     // print(_pageController!.page! > 0);
//     // print(details.localPosition.dx < 50);
//     // print(_childpageController!.page!.toInt() == 0);
//     if (_pageController!.page! > 0 &&
//         // details.localPosition.dx < 50
//         dx < screenwidth / 3 &&
//         _childpageController!.page!.toInt() == 0) {
//       _pageController!.animateToPage(
//         _pageController!.page!.toInt() - 1, // Go to the previous page
//         duration: const Duration(
//             milliseconds: 300), // Adjust duration for smooth animation
//         curve: Curves.easeInOut, // Use the same curve for smooth transition
//       );
//       _currentIndex = 0;
//       _loadStory(story: stories[_currentIndex], stories: stories);
//       return;
//     }

//     if (dx < screenwidth / 3) {
//       print('object');
//       setState(() {
//         if (_currentIndex - 1 >= 0) {
//           _currentIndex -= 1;
//           _loadStory(story: stories[_currentIndex], stories: stories);
//         }
//         // else if (_currentIndex == 0) {
//         //   _pageController!.previousPage(
//         //       duration: const Duration(milliseconds: 1),
//         //       curve: Curves.easeInOut);
//         // }
//       });
//     } else if (dx > 2 * screenwidth / 3) {
//       print('objec2t2');

//       setState(() {
//         if (_currentIndex + 1 < stories.length) {
//           _currentIndex += 1;
//           _loadStory(story: stories[_currentIndex], stories: stories);
//           print('123');
//         } else {
//           _currentIndex = 0;
//           _loadStory(story: stories[_currentIndex], stories: stories);
//           print('77777');
//         }
//       });
//       print('{currentIndex: $_currentIndex}');
//     } else {
//       print('object3');

//       if (story.media == MediaType.video && _videoPlayerController != null) {
//         print('object43');
//         if (_videoPlayerController!.value.isPlaying) {
//           _videoPlayerController!.pause();
//           _animationController!.stop();
//         } else {
//           _videoPlayerController!.play();
//           _animationController!.forward();
//         }
//       }
//     }
//   }

//   void _loadStory(
//       {required Story story,
//       bool animationToPage = true,
//       required List<Story> stories}) {
//     _animationController!.stop();
//     _animationController!.reset();
//     if (_videoPlayerController != null) {
//       print(
//           '////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////');
//       print('video reset');
//       _videoPlayerController!.pause();
//       _videoPlayerController!.dispose();
//       _videoPlayerController = null; // Clear the reference
//     }
//     switch (story.media) {
//       case MediaType.image:
//         print('2object${story.media}this');
//         _animationController!.duration = story.duration;
//         _animationController!.forward();
//         break;
//       case MediaType.video:
//         print('2object${story.media}');
//         print('2object${story.url}');
//         print('2object${story.storyId}');
//         print('2object${story.timestamp}');
//         _videoPlayerController = VideoPlayerController.networkUrl(
//           Uri.parse(story.url),
//           videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
//         )
//           ..setLooping(true)
//           ..initialize().then((value) {
//             print('video contorller cllickec first');
//             setState(() {});
//             if (_videoPlayerController!.value.isInitialized) {
//               _animationController!.duration =
//                   _videoPlayerController!.value.duration;

//               _videoPlayerController!.addListener(() {
//                 if (_videoPlayerController!.value.position >=
//                     _videoPlayerController!.value.duration) {
//                   // Move to the next story when the video ends
//                   // Reset the animation controller
//                   _animationController!.stop();
//                   _animationController!.reset();
//                   if (_videoPlayerController!.value.hasError) {
//                     print(
//                         'Video Player Error: ${_videoPlayerController!.value.errorDescription}');
//                   }

//                   // Move to the next story if available, otherwise reset to the first story
//                   setState(() {
//                     if (_currentIndex + 1 < stories.length) {
//                       _currentIndex += 1;
//                       _loadStory(
//                           story: stories[_currentIndex], stories: stories);
//                     } else {
//                       _currentIndex = 0;
//                       _loadStory(
//                           story: stories[_currentIndex], stories: stories);
//                     }
//                   });
//                 }
//                 // If the video is playing, continue the animation
//                 if (_videoPlayerController!.value.isPlaying) {
//                   _animationController!.forward();
//                 } else {
//                   // If the video is paused or buffering, stop the animation
//                   _animationController!.stop();
//                 }
//               });
//               _videoPlayerController!.play();
//               _animationController!.forward();
//             }
//           }).catchError((error) {
//             print('Error initializing video: $error');
//           });
//         break;
//     }
//     if (animationToPage) {
//       _childpageController!.animateToPage(
//         _currentIndex,
//         duration: const Duration(milliseconds: 1),
//         curve: Curves.easeInOut,
//       );
//     }
//     setState(() {});
//   }
// }

// num degToRad(num deg) => deg * (pi / 180.0);
// num radToDeg(num deg) => deg * (180.0 / pi);
