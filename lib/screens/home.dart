import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/services.dart';
import 'package:instagram_clone/widgets/story/components/stories_list_skeleton.dart';

import 'package:instagram_clone/widgets/story_button.dart';

class Home extends ConsumerWidget {
  Home({super.key});

  dynamic futureAlbum;

  // Listen to the userProvider

// Assuming User class is defined somewhere

  @override
  Widget build(BuildContext context, ref) {
    final futureAlbum = ref.watch(userProvider);

    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          AppBar(
            backgroundColor: Colors.black,
            title: SvgPicture.asset(
              'assets/ic_instagram.svg',
              color: Colors.white,
              // color: primaryColor,
              height: 32,
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.message),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          // StoryButton(),
          SizedBox(
            height: 120,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              physics: const ScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(
                                2.0), // Padding to create a gap between the border and the avatar
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.pink,
                                  Colors.orange,
                                  Colors.yellow
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Container(
                                padding: const EdgeInsets.all(
                                    2.0), // Gap between border and image
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors
                                      .black, // Background color for the gap
                                ),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
                                    width: 72,
                                    height: 72,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        StoriesListSkeletonAlone(
                                      width: 72,
                                      height: 72,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error, size: 72),
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
                          const SizedBox(height: 4),
                          const Text('Your Story',
                              style: TextStyle(
                                fontSize: 10,
                              )),
                        ],
                      ),
                      Positioned(
                        right: 4.0,
                        bottom: 22.0,
                        child: Container(
                          width: 28.0,
                          height: 28.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                            border: Border.all(
                                width: 2,
                                color: const Color.fromARGB(255, 11, 6, 6)),
                          ),
                          child: const Icon(Icons.add,
                              size: 18.0, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
//                 FutureBuilder<dynamic>(
//                   future: futureAlbum, // Your future that fetches user data
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Container(
//                         height: 120, // Set a height for the container
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           primary: false,
//                           shrinkWrap: true,
//                           itemCount: 3,
//                           itemBuilder: (BuildContext context, int index) {
//                             return Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8.0,
//                               ),
//                               child: Column(
//                                 children: [
//                                   InkWell(
//                                     child: Container(
//                                       width: 72,
//                                       height: 72,
//                                       child: Stack(
//                                         children: <Widget>[
//                                           ClipRRect(
//                                             borderRadius:
//                                                 const BorderRadius.all(
//                                                     Radius.circular(36)),
//                                             child: StoriesListSkeletonAlone(
//                                               width: 72,
//                                               height: 72,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   const Text(' ')
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     }

//                     //   Center(
//                     //       child: CircularProgressIndicator()); // Loading state
//                     // }
//                     if (snapshot.hasError) {
//                       return Container(
//                         height: 120, // Set a height for the container
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           primary: false,
//                           shrinkWrap: true,
//                           itemCount: 3,
//                           itemBuilder: (BuildContext context, int index) {
//                             return Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8.0,
//                               ),
//                               child: Column(
//                                 children: [
//                                   InkWell(
//                                     child: Container(
//                                       width: 72,
//                                       height: 72,
//                                       child: Stack(
//                                         children: <Widget>[
//                                           ClipRRect(
//                                             borderRadius:
//                                                 const BorderRadius.all(
//                                                     Radius.circular(36)),
//                                             child: StoriesListSkeletonAlone(
//                                               width: 72,
//                                               height: 72,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   const Text(' ')
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                       // return Center(
//                       //     child: Text(
//                       //         'Error: ${snapshot.error}')); // Display error
//                     }
//                     if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return const Center(
//                           child: Text('No users found.')); // No data state
//                     }

//                     // Assuming snapshot.data is a List<User>
//                     final List<User> userDocs = snapshot.data!; // L

//                     return Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: List.generate(userDocs.length, (index) {
//                         final user = userDocs[index];

//                         return Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal:
//                                     8.0), // Optional padding between story buttons
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
// //                                     Navigator.push(
// //                                       context,
// //                                       NoAnimationMaterialPageRoute(
// //                                         builder: (context) => GroupedStory(
// //                                           futureAlbum: futureAlbum,
// //                                           // storyData: user.stories,

// //                                           tappedUserData: user,

// //                                           // captionTextStyle:
// //                                           //     widget.captionTextStyle,
// //                                           // captionPadding: widget.captionPadding,
// //                                           // captionMargin: widget.captionMargin,
// //                                         ),
// //                                         // settings: RouteSettings(
// //                                         //   arguments: StoriesListWithPressed(
// //                                         //       pressedStoryId: story.storyId,
// //                                         //       storiesIdsList: storiesIdsList),
// //                                         // ),
// //                                       ),
// // //                        ModalRoute.withName('/'),
// //                                     );
// //                                     Navigator.push(
// //                                       context,
// //                                       NoAnimationMaterialPageRoute(
// //                                         builder: (context) =>
// //                                             GroupedStoriesView(
// //                                               futureAlbum:futureAlbum,
// //                                           // storyData: user.stories,
// //                                           tappedUserData: user,
// //                                           imageStoryDuration:
// //                                               4,
// //                                           progressPosition:
// //                                               ProgressPosition.top,
// //                                           repeat: false,
// //                                           inline: false,
// //                                           backgroundColorBetweenStories:Colors.black,
// //                                           closeButtonIcon:
// //                                               Icon(Icons.close, color: Colors.white),
// //                                           closeButtonBackgroundColor:
// //                                               Colors.transparent,
// //                                           sortingOrderDesc:
// //                                               false,
// //                                           // captionTextStyle:
// //                                           //     widget.captionTextStyle,
// //                                           // captionPadding: widget.captionPadding,
// //                                           // captionMargin: widget.captionMargin,
// //                                         ),
// //                                         // settings: RouteSettings(
// //                                         //   arguments: StoriesListWithPressed(
// //                                         //       pressedStoryId: story.storyId,
// //                                         //       storiesIdsList: storiesIdsList),
// //                                         // ),
// //                                       ),
// // //                        ModalRoute.withName('/'),
// //                                     );
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => StoryDetailPage(
//                                           stories: [
//                                             ...user.stories,
//                                           ],
//                                           futureAlbum: futureAlbum,
//                                           initialIndex: 0,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   splashColor: Colors.transparent,
//                                   child: Hero(
//                                     tag: '${user.userId}',
//                                     child: Container(
//                                       padding: const EdgeInsets.all(
//                                           2.0), // Padding to create a gap between the border and the avatar
//                                       decoration: const BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             Colors.pink,
//                                             Colors.orange,
//                                             Colors.yellow
//                                           ],
//                                           begin: Alignment.topLeft,
//                                           end: Alignment.bottomRight,
//                                         ),
//                                       ),
//                                       child: Container(
//                                           padding: const EdgeInsets.all(
//                                               2.0), // Gap between border and image
//                                           decoration: const BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             color: Colors
//                                                 .black, // Background color for the gap
//                                           ),
//                                           child: ClipOval(
//                                             child: CachedNetworkImage(
//                                               imageUrl: user.profilePicture,
//                                               width: 72,
//                                               height: 72,
//                                               fit: BoxFit.cover,
//                                               placeholder: (context, url) =>
//                                                   StoriesListSkeletonAlone(
//                                                 width: 72,
//                                                 height: 72,
//                                               ),
//                                               errorWidget:
//                                                   (context, url, error) =>
//                                                       const Icon(Icons.error,
//                                                           size: 72),
//                                             ),
//                                           )
//                                           // CircleAvatar(
//                                           //   radius: 36,
//                                           //   backgroundImage: NetworkImage(
//                                           //     user.profilePicture,
//                                           //   ),
//                                           // ),
//                                           ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   user.userName,
//                                   style: const TextStyle(
//                                     fontSize: 10,
//                                   ),
//                                 ),
//                               ],
//                             ));
//                       }),
//                     );
//                   },
//                 )
                SizedBox(
                  height: 120,
                  child: futureAlbum.when(
                    data: (users) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: users.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    // Handle navigation to user stories
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(
                                        2.0), // Padding to create a gap between the border and the avatar
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.pink,
                                          Colors.orange,
                                          Colors.yellow
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(
                                          2.0), // Gap between border and image
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors
                                            .black, // Background color for the gap
                                      ),
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: user.profilePicture,
                                          width: 72,
                                          height: 72,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              StoriesListSkeletonAlone(
                                            width: 72,
                                            height: 72,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error, size: 72),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(user.userName,
                                    style: const TextStyle(fontSize: 10)),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    loading: () =>
                       Container(
                        height: 120, // Set a height for the container
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          primary: false,
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Column(
                                children: [
                                  InkWell(
                                    child: Container(
                                      width: 72,
                                      height: 72,
                                      child: Stack(
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(36)),
                                            child: StoriesListSkeletonAlone(
                                              width: 72,
                                              height: 72,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(' ')
                                ],
                              ),
                            );
                          },
                        ),
                      
                      ),
                    error: (error, stack) =>
                        Center(child: Text('Error: $error')),
                  ),
                ),
              ],
            ),
          ),

          // StoryButton(),
          ListView(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      const ListTile(
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(
                            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
                          ),
                        ),
                        title: Text('abhishek.vedant'),
                        trailing: Icon(Icons.more_vert),
                      ),
                      Image.network(
                        'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
                        fit: BoxFit.cover,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.favorite_border),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.comment),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
