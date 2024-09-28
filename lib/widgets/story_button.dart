import 'package:flutter/material.dart';
import 'package:instagram_clone/models/story.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/widgets/video_player.dart';

class StoryButton extends StatelessWidget {
  User user;

  String tag;

  StoryButton({super.key, required this.user, required this.tag});

  void _onStoryTap(BuildContext context) {
    // Navigate to the detailed page with a hero animation
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => StoryDetailPage(
    //       imageUrl: user.profilePicture,
    //       tag: tag,
    //     ),
    //   ),
    // );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryDetailPage(
          stories: [
            ...user.stories,
          ],
          initialIndex: 0, // Start from the first story
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

// class StoryDetailPage extends StatelessWidget {
//   final String? imageUrl;
//   final String tag;

//   const StoryDetailPage({super.key, this.imageUrl, required this.tag});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           Center(
//             child: Hero(
//               tag: tag, // Same tag as used in the previous screen
//               child: Image.network(
//                 imageUrl ?? 'https://randomuser.me/api/portraits/men/7.jpg',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Positioned(
//             top: 40,
//             left: 16,
//             child: IconButton(
//               icon: const Icon(Icons.close, color: Colors.white),
//               onPressed: () {
//                 Navigator.pop(context); // Close the story detail
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class StoryDetailPage extends StatelessWidget {
//   final List<String> imageUrls; // List of story image URLs
//   final int initialIndex; // The index of the initial story to display

//   const StoryDetailPage({
//     super.key,
//     required this.imageUrls,
//     required this.initialIndex,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: PageView.builder(
//         itemCount: imageUrls.length,
//         controller: PageController(initialPage: initialIndex),
//         itemBuilder: (context, index) {
//           return Stack(
//             children: [
//               Center(
//                 child: Hero(
//                   tag: imageUrls[
//                       index], // Use the image URL as a tag for the hero animation
//                   child: Image.network(
//                     imageUrls[index],
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 40,
//                 left: 16,
//                 child: IconButton(
//                   icon: const Icon(Icons.close, color: Colors.white),
//                   onPressed: () {
//                     Navigator.pop(context); // Close the story detail
//                   },
//                 ),
//               ),
//               // Add more functionality for tapping to change stories
//               GestureDetector(
//                 onTap: () {
//                   // Add any specific action when tapping on the image (if needed)
//                 },
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class StoryDetailPage extends StatefulWidget {
//   final List<Story> stories; // List of story image URLs
//   final int initialIndex; // The index of the initial story to display

//   const StoryDetailPage({
//     super.key,
//     required this.stories,
//     required this.initialIndex,
//   });

//   @override
//   _StoryDetailPageState createState() => _StoryDetailPageState();
// }

// class _StoryDetailPageState extends State<StoryDetailPage> {
//   late PageController _pageController;
//   late int _currentIndex;

//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.initialIndex;
//     _pageController = PageController(initialPage: _currentIndex);
//     _pageController.addListener(() {
//       setState(() {
//         _currentIndex = _pageController.page!.round(); // Update current index
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       // appBar: AppBar(
//       //   backgroundColor: Colors.black,
//       //   automaticallyImplyLeading: false,
//       //   title: Row(
//       //     mainAxisAlignment: MainAxisAlignment.center,
//       //     children: List.generate(widget.imageUrls.length, (index) {
//       //       return Expanded(
//       //         child: Container(
//       //           margin: const EdgeInsets.symmetric(horizontal: 2.0),
//       //           height: 2.0,
//       //           decoration: BoxDecoration(
//       //             color: _currentIndex == index ? Colors.white : Colors.grey,
//       //             borderRadius: BorderRadius.circular(8.0),
//       //           ),
//       //         ),
//       //       );
//       //     }),
//       //   ),
//       // ),
//       body: Stack(
//         children: [
//           PageView.builder(
//             itemCount: widget.stories.length,
//             controller: _pageController,
//             itemBuilder: (context, index) {
//               final story = widget.stories[index];
//               return story.mediaType == 'image'
//                   ? Center(
//                       child: Hero(
//                         tag: widget.stories[
//                             index], // Use the image URL as a tag for the hero animation
//                         child: Image.network(
//                           story.mediaUrl,
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                     )
//                   : Container();
//             },
//           ),
//           Positioned(
//             top: 80,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(widget.stories.length, (index) {
//                 return Expanded(
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 2.0),
//                     height: 2.0,
//                     decoration: BoxDecoration(
//                       color:
//                           _currentIndex == index ? Colors.white : Colors.grey,
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//           TitleListTile(),
//         ],
//       ),
//     );
//   }
// }
class StoryDetailPage extends StatefulWidget {
  final List<Story> stories; // List of stories with attributes
  final int initialIndex; // The index of the initial story to display

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

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page!.round(); // Update current index
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTap: _onTapRight, // Change story on right tap
            onHorizontalDragEnd: (details) {
              if (details.velocity.pixelsPerSecond.dx < 0) {
                _onTapRight(); // Swipe left to next story
              } else {
                _onTapLeft(); // Swipe right to previous story
              }
            },
            child: PageView.builder(
              itemCount: widget.stories.length,
              controller: _pageController,
              itemBuilder: (context, index) {
                final story = widget.stories[index];

                return story.mediaType == 'image'
                    ? Center(
                        child: Hero(
                          tag: story
                              .mediaUrl, // Use the image URL as a tag for the hero animation
                          child: Image.network(
                            story.mediaUrl,
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    : VideoApp();
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
                    decoration: BoxDecoration(
                      color:
                          _currentIndex == index ? Colors.white : Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),
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
