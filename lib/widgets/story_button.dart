// import 'dart:async';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:instagram_clone/models/story_model.dart';
// import 'package:instagram_clone/models/user_model.dart';
// import 'package:instagram_clone/services.dart';
// import 'package:instagram_clone/widgets/image_view.dart';
// import 'package:instagram_clone/widgets/story/components/contoller.dart';
// import 'package:instagram_clone/widgets/story/components/image_view.dart';
// import 'package:instagram_clone/widgets/story/components/stories_list_skeleton.dart';

// import 'package:instagram_clone/widgets/story/components/video_player.dart';
// import 'package:video_player/video_player.dart';

// class StoryDetailPage extends ConsumerStatefulWidget {
//   final int initialIndex;
//   final User? tappedUserData;

//   const StoryDetailPage({
//     Key? key,
//     required this.initialIndex,
//     this.tappedUserData,
//   }) : super(key: key);

//   @override
//   _StoryDetailPageState createState() => _StoryDetailPageState();
// }

// class _StoryDetailPageState extends ConsumerState<StoryDetailPage> {
//   late PageController _pageController;
//   late StoryController _storyController;

//   late int _currentIndex;
//   late double _progress; // Variable to track progress
//   bool _isPaused = false; // To track whether progress is paused

//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.initialIndex;
//     _progress = 0.0; // Initialize progress
//     _pageController = PageController(initialPage: _currentIndex);
//     _pageController.addListener(() {
//       setState(() {
//         _currentIndex = _pageController.page!.round(); // Update current index
//         _resetProgress(); // Reset progress when changing stories
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     // storyController.dispose();

//     super.dispose();
//   }

//   void _resetProgress() {
//     setState(() {
//       _progress = 0.0; // Reset progress
//     });
//   }

//   void _onVideoEnd() {
//     // if (_currentIndex < widget.stories.length - 1) {
//     //   _pageController.nextPage(
//     //     duration: const Duration(milliseconds: 300),
//     //     curve: Curves.easeInOut,
//     //   );
//     // }
//   }

//   void _updateProgress(VideoPlayerController controller) {
//     if (controller.value.isInitialized) {
//       double progress = controller.value.position.inSeconds.toDouble() /
//           controller.value.duration.inSeconds.toDouble();
//       setState(() {
//         _progress =
//             progress.clamp(0.0, 1.0); // Ensure progress is between 0 and 1
//       });
//     }
//   }

//   void _onHold() {
//     setState(() {
//       _isPaused = true; // Pause the linear progress
//     });
//   }

//   void _onRelease() {
//     setState(() {
//       _isPaused = false; // Resume linear progress
//     });
//   }

//   _navigateBack() {
//     return Navigator.pushNamedAndRemoveUntil(
//       context,
//       '/',
//       (_) => false,
//       arguments: 'back_from_stories_view',
//     );
//   }

//   // void _onStoryShow(StoryItem s) {}

//   static pageGif(
//     String? url, {
//     StoryController? controller,
//     BoxFit imageFit = BoxFit.fitWidth,
//     String? caption,
//     bool shown = false,
//     Duration duration = const Duration(seconds: 3),
//     Map<String, dynamic>? requestHeaders,
//     TextStyle? captionTextStyle,
//     EdgeInsets? captionMargin,
//     EdgeInsets? captionPadding,
//   }) {
//     return Container(
//       color: Colors.black,
//       child: Stack(
//         children: <Widget>[
//           StoryImage.url(
//             url,
//             controller: controller,
//             fit: imageFit,
//             requestHeaders: requestHeaders,
//           ),
//           caption != null && caption.length > 0
//               ? SafeArea(
//                   child: Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Container(
//                       width: double.infinity,
//                       margin: captionMargin,
//                       padding: captionPadding,
//                       color: caption.length > 0 ? Colors.black54 : Colors.red,
//                       child: caption.length > 0
//                           ? Text(
//                               caption,
//                               style: captionTextStyle,
//                               textAlign: TextAlign.center,
//                             )
//                           : SizedBox(),
//                     ),
//                   ),
//                 )
//               : Container(),
//         ],
//       ),
//     );
//   }

//   Widget currentView(User tappedUserData, users) {
//     return users.firstWhere(
//       (it) => it != tappedUserData,
//       orElse: () => users.last,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () {
//         _navigateBack();
//         return Future.value(false);
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Container(
//           color: Colors.black,
//           child: ref.watch(userProvider).when(
//               loading: () => StoriesListSkeleton(),
//               error: (error, stack) => Center(child: Text('Error: $error')),
//               data: (users) {
//                 // Widget _currentView =
//                 //     currentView(widget.tappedUserData!, users);

//                 return Stack(
//                   children: [
//                     GestureDetector(
//                       onTapDown: (TapDownDetails details) {
//                         double tapX = details.globalPosition.dx;
//                         double screenWidth = MediaQuery.of(context).size.width;

//                         if (tapX < screenWidth / 2) {
//                           _pageController.previousPage(
//                             duration: const Duration(milliseconds: 300),
//                             curve: Curves.easeInOut,
//                           );
//                         } else {
//                           _pageController.nextPage(
//                             duration: const Duration(milliseconds: 300),
//                             curve: Curves.easeInOut,
//                           );
//                         }
//                       },
//                       onLongPressStart: (_) => _onHold(), // Pause on hold
//                       onLongPressEnd: (_) => _onRelease(), // Resume on release
//                       child: PageView.builder(
//                         physics: const NeverScrollableScrollPhysics(),
//                         // itemCount: widget.tappedUserData!.stories.length,
//                         // ??widget.stories.length,
//                         controller: _pageController,
//                         itemBuilder: (context, index) {
//                           // final story =  ref.watch(userProvider)[index];
//                           // final story = widget.tappedUserData!.stories[index];
//                           // final story = widget.stories[index];
//                           final story = [][index];
//                           // final ImageLoader imageLoader =
//                           //     ImageLoader(story.mediaUrl);
//                           // final VideoLoader videoLoader =
//                           //     VideoLoader(story.mediaUrl);
//                           print(story.mediaType);
//                           return story.mediaType == 'image'
//                               ?
//                               // pageGif(
//                               //     story.mediaUrl,
//                               //     controller: _storyController,
//                               //     // caption: story.caption,
//                               //   )
//                               Center(
//                                   child: Hero(
//                                     tag: story.url,
//                                     child: ImageView(story: story),
//                                   ),
//                                 )
//                               :
//                               // StoryVideo(videoLoader);
//                               VideoApp(
//                                   onVideoEnd: _onVideoEnd,
//                                   videoUrl: story.url,
//                                   isPaused: _isPaused,
//                                   onProgressUpdate: (controller) =>
//                                       _updateProgress(controller),
//                                 );
//                         },
//                       ),
//                     ),
//                     Positioned(
//                       top: 80,
//                       left: 0,
//                       right: 0,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children:
//                             List.generate(
//                               // widget.tappedUserData!.stories.length,
//                                 10,
//                                 // widget.stories.length,
//                                 (index) {
//                           return Expanded(
//                             child: Container(
//                               margin:
//                                   const EdgeInsets.symmetric(horizontal: 2.0),
//                               height: 2.0,
//                               child: Stack(
//                                 alignment: Alignment.center,
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: _currentIndex > index
//                                           ? Colors.white
//                                           : Colors.grey,
//                                       borderRadius: BorderRadius.circular(8.0),
//                                     ),
//                                   ),
//                                   if (_currentIndex == index)
//                                     LinearProgressIndicator(
//                                       value: _progress,
//                                       backgroundColor: Colors.transparent,
//                                       valueColor:
//                                           const AlwaysStoppedAnimation<Color>(
//                                               Colors.white),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }),
//                       ),
//                     ),
//                   ],
//                 );
//               }),
//         ),
//       ),
//     );
//   }
// }

// class TitleListTile extends StatelessWidget {
//   const TitleListTile({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const ListTile(
//       leading: CircleAvatar(
//         radius: 36,
//         backgroundImage: NetworkImage(
//           'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
//         ),
//       ),
//       title: Text('Stories'),
//       trailing: Icon(Icons.arrow_forward),
//     );
//   }
// }

// class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
//   NoAnimationMaterialPageRoute({
//     required WidgetBuilder builder,
//     RouteSettings? settings,
//     bool maintainState = true,
//     bool fullscreenDialog = false,
//   }) : super(
//             builder: builder,
//             maintainState: maintainState,
//             settings: settings,
//             fullscreenDialog: fullscreenDialog);

//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     return child;
//   }
// }
