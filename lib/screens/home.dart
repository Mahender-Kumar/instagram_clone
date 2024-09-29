import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/services.dart';
import 'package:instagram_clone/widgets/story/components/stories_list_skeleton.dart';

// ignore: must_be_immutable
class Home extends ConsumerWidget {
  Home({super.key});

  dynamic futureAlbum;

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
              // ignore: deprecated_member_use
              color: Colors.white,

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
                            padding: const EdgeInsets.all(2.0),
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
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.all(2.0),
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
                                      padding: const EdgeInsets.all(2.0),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
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
                    loading: () => SizedBox(
                      height: 120,
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
                                  child: SizedBox(
                                    width: 72,
                                    height: 72,
                                    child: Stack(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(
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
