// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:instagram_clone/models/story.dart';  
// class GroupedStory extends ConsumerStatefulWidget {
//   const GroupedStory({super.key});

//   @override
//   ConsumerState<GroupedStory> createState() => _GroupedStoryState();
// }

// class _GroupedStoryState extends ConsumerState<GroupedStory> {
//   int _currentUserIndex = 0; // Track the current user index
//   int _currentStoryIndex = 0; // Track the current story index

//   @override
//   Widget build(BuildContext context) {
//     // Retrieve user data from the provider
//     final userProvider = ref.watch(userProvider);
//     final users = userProvider.users; // Assuming userProvider has a list of users

//     if (users.isEmpty) {
//       return Center(child: Text("No users available."));
//     }

//     final currentUser = users[_currentUserIndex]; // Get the current user
//     final userStories = currentUser.stories; // Get stories of the current user

//     if (userStories.isEmpty) {
//       return Center(child: Text("No stories available for ${currentUser.userName}."));
//     }

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onHorizontalDragEnd: (details) {
//           if (details.velocity.pixelsPerSecond.dx > 0) {
//             _navigateToPreviousUserStory();
//           } else {
//             _navigateToNextUserStory();
//           }
//         },
//         child: Column(
//           children: [
//             Expanded(
//               child: Center(
//                 child: Text(
//                   userStories[_currentStoryIndex].title, // Display the title of the current story
//                   style: TextStyle(color: Colors.white, fontSize: 24),
//                 ),
//               ),
//             ),
//             FloatingActionButton(
//               onPressed: () => _navigateToStoryDetails(userStories[_currentStoryIndex]),
//               child: Icon(Icons.info),
//               backgroundColor: Colors.white,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _navigateToPreviousUserStory() {
//     if (_currentStoryIndex > 0) {
//       setState(() {
//         _currentStoryIndex--;
//       });
//     } else if (_currentUserIndex > 0) {
//       setState(() {
//         _currentUserIndex--;
//         _currentStoryIndex = ref.watch(userProvider).users[_currentUserIndex].stories.length - 1;
//       });
//     } else {
//       // Optionally handle the case where there are no more previous stories
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("No previous story.")),
//       );
//     }
//   }

//   void _navigateToNextUserStory() {
//     final userProvider = ref.watch(userProvider);
//     final users = userProvider.users;
//     final currentUser = users[_currentUserIndex];
//     if (_currentStoryIndex < currentUser.stories.length - 1) {
//       setState(() {
//         _currentStoryIndex++;
//       });
//     } else if (_currentUserIndex < users.length - 1) {
//       setState(() {
//         _currentUserIndex++;
//         _currentStoryIndex = 0; // Reset to the first story of the next user
//       });
//     } else {
//       // Optionally handle the case where there are no more next stories
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("No next story.")),
//       );
//     }
//   }

//   void _navigateToStoryDetails(Story story) {
//     // Navigate to the story details page
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => StoryDetailsPage(story: story),
//       ),
//     );
//   }
// }
