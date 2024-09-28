import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/models/story.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/widgets/story/components/stories_list_skeleton.dart';
import 'package:instagram_clone/widgets/story_button.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  dynamic futureAlbum;

  initState() {
    super.initState();
    futureAlbum = fetchUsers();
  }

// Assuming User class is defined somewhere
  Future<List<User>> fetchUsers() async {
    print('Called fetchUsers');
    try {
      final response =
          await http.get(Uri.parse('https://ixifly.in/flutter/task2'));

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');

        print('Response received successfully');
        // Parse the JSON and return a list of users
        dynamic jsonResponse = jsonDecode(response.body);
        List<dynamic> jsonData = jsonResponse['data'];
        print('JSON response: $jsonData');

        return jsonData.map((user) => User.fromJson(user)).toList();
      } else {
        print('Error: ${response.statusCode}');
        throw Exception(
            'Failed to load users, status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the fetch
      print('An error occurred: $e');
      throw Exception('Failed to load users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      StoryButton(
                        user: User(
                            userId: 132123123,
                            userName: 'Your Story',
                            profilePicture:
                                'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
                            stories: []),
                        tag: 'mahe',
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
                          child:
                              Icon(Icons.add, size: 18.0, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder<dynamic>(
                  future: futureAlbum, // Your future that fetches user data
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: 120, // Set a height for the container
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          primary: false,
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
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
                                            borderRadius: BorderRadius.all(
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
                                  Text(' ')
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }

                    //   Center(
                    //       child: CircularProgressIndicator()); // Loading state
                    // }
                    if (snapshot.hasError) {
                      return Container(
                        height: 120, // Set a height for the container
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          primary: false,
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
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
                                            borderRadius: BorderRadius.all(
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
                                  Text(' ')
                                ],
                              ),
                            );
                          },
                        ),
                      );
                      // return Center(
                      //     child: Text(
                      //         'Error: ${snapshot.error}')); // Display error
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text('No users found.')); // No data state
                    }

                    // Assuming snapshot.data is a List<User>
                    final List<User> userDocs = snapshot.data!; // L

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(userDocs.length, (index) {
                        final user = userDocs[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal:
                                  8.0), // Optional padding between story buttons
                          child: StoryButton(
                            user: user,
                            tag: '${user.userName}$index',
                          ),
                        );
                      }),
                    );
                  },
                )

                // ListView.builder(
                //   scrollDirection: Axis.horizontal,
                //   shrinkWrap: true,
                //   itemCount: 5,
                //   itemBuilder: (context, index) => Story(),
                // ),
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
                      ListTile(
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(
                            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
                          ),
                        ),
                        title: const Text('abhishek.vedant'),
                        trailing: const Icon(Icons.more_vert),
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
