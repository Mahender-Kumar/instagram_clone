import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/models/story_model.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/models/user_story.dart';
import 'package:instagram_clone/screens/story/dashed_circle.dart';
import 'package:instagram_clone/screens/story/rect_getter.dart';
import 'package:instagram_clone/screens/story/story_view.dart';
import 'package:instagram_clone/services.dart';
import 'package:instagram_clone/widgets/story/components/stories_list_skeleton.dart';
import 'package:instagram_clone/page_animations/page_routes_animation.dart';
import 'package:instagram_clone/widgets/story_button.dart';

// ignore: must_be_immutable

const Duration animationDuration = Duration(seconds: 1);
const Duration delay = Duration(seconds: 1);

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> with TickerProviderStateMixin {
  GlobalKey<RectGetterState> reactGetterkey = RectGetter.createGlobalKey();
  Rect? rect;
  AnimationController? storyAnimationController;
  Animation? storycolorAnimation;

  dynamic futureAlbum;

  @override
  void initState() {
    super.initState();
    storyAnimationController =
        AnimationController(vsync: this, duration: animationDuration);
    storycolorAnimation = ColorTween(begin: Colors.black12, end: Colors.black)
        .animate(storyAnimationController!);
    storyAnimationController!.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
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
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(
                                          FadeRouteBuilder(
                                            page: StoryFeedView(
                                                stories: user.stories!,
                                                //  [
                                                //   UserStoryList(
                                                //       user: User(
                                                //         name: 'The Flutter Pro fit',
                                                //         profileImageUrl:
                                                //             'http://m.gettywallpapers.com/wp-content/uploads/2021/03/Cool-HD-Wallpaper.jpg',
                                                //       ),
                                                //       story: stories),
                                                //   UserStoryList(
                                                //       user: User(
                                                //         name: 'The Flutter Pro fit 1',
                                                //         profileImageUrl:
                                                //             'http://m.gettywallpapers.com/wp-content/uploads/2021/03/Cool-HD-Wallpaper.jpg',
                                                //       ),
                                                //       story: stories),
                                                //   UserStoryList(
                                                //       user: User(
                                                //         name: 'The Flutter Pro fit 2',
                                                //         profileImageUrl:
                                                //             'http://m.gettywallpapers.com/wp-content/uploads/2021/03/Cool-HD-Wallpaper.jpg',
                                                //       ),
                                                //       story: stories),
                                                // ],
                                                herotagString: '${user.userId}'),
                                          ),
                                        )
                                        .then((value) =>
                                            setState(() => rect = null));
                                    // Navigator.push(
                                    //   context,
                                    //   NoAnimationMaterialPageRoute(
                                    //     builder: (context) => StoryDetailPage(
                                    //       initialIndex: 0,
                                    //       tappedUserData: user,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  child: Hero(
                                    tag: '${user.userId}',
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
                                            imageUrl: user.profileImageUrl,
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
                                ),
                                const SizedBox(height: 4),
                                Text(user.name,
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
          // SizedBox(
          //   height: 120,
          //   child: ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     padding: EdgeInsets.symmetric(horizontal: 8),
          //     itemBuilder: (context, index) {
          //       return UserStoryItem(
          //         setRectPoint: (rectpoint) {
          //           print(rect);
          //           setState(() {
          //             rect = rectpoint;
          //           });
          //           onStoryItemTap(rect, index);
          //         },
          //         index: index,
          //       );
          //     },
          //   ),
          // ),
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

  void onStoryItemTap(reactpoint, index) {
    setState(() => rect = reactpoint);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() =>
          rect = rect!.inflate(1.3 * MediaQuery.of(context).size.longestSide));
      storyAnimationController!.forward();
      Future.delayed(animationDuration, () {
        User user = User(
          name: 'presence.fit',
          profileImageUrl:
              'http://m.gettywallpapers.com/wp-content/uploads/2021/03/Cool-HD-Wallpaper.jpg',
        );

        List<Story> stories = [
          Story(
            url:
                'https://cdn.pixabay.com/photo/2018/01/14/23/12/nature-3082832_1280.jpg',
            media: MediaType.image,
            // user: user,
            duration: Duration(seconds: 5),
          ),
          Story(
            url: 'assets/v1.mp4',
            media: MediaType.video,
            duration: Duration(seconds: 0),
            // user: user,
          ),
          Story(
            url: 'assets/v2.mp4',
            media: MediaType.video,
            duration: Duration(seconds: 0),
            // user: user,
          ),
          Story(
            url:
                'https://images.unsplash.com/photo-1531694611353-d4758f86fa6d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=564&q=80',
            media: MediaType.image,
            duration: Duration(seconds: 5),
            // user: user,
          ),
          Story(
            url: 'assets/v3.mp4',
            media: MediaType.video,
            duration: Duration(seconds: 0),
            // user: user,
          ),
        ];
        Navigator.of(context)
            .push(
              FadeRouteBuilder(
                page: StoryFeedView(
                    stories: stories,
                    //  [
                    //   UserStoryList(
                    //       user: User(
                    //         name: 'The Flutter Pro fit',
                    //         profileImageUrl:
                    //             'http://m.gettywallpapers.com/wp-content/uploads/2021/03/Cool-HD-Wallpaper.jpg',
                    //       ),
                    //       story: stories),
                    //   UserStoryList(
                    //       user: User(
                    //         name: 'The Flutter Pro fit 1',
                    //         profileImageUrl:
                    //             'http://m.gettywallpapers.com/wp-content/uploads/2021/03/Cool-HD-Wallpaper.jpg',
                    //       ),
                    //       story: stories),
                    //   UserStoryList(
                    //       user: User(
                    //         name: 'The Flutter Pro fit 2',
                    //         profileImageUrl:
                    //             'http://m.gettywallpapers.com/wp-content/uploads/2021/03/Cool-HD-Wallpaper.jpg',
                    //       ),
                    //       story: stories),
                    // ],
                    herotagString: 'index$index'),
              ),
            )
            .then((value) => setState(() => rect = null));
      });
    });
  }

  Widget rippleAnimation() {
    if (rect == null) {
      return const Offstage();
    }
    return AnimatedPositioned(
      left: rect!.left,
      right: MediaQuery.of(context).size.width - rect!.right,
      top: rect!.top,
      bottom: MediaQuery.of(context).size.height - rect!.bottom,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: storycolorAnimation!.value,
        ),
      ),
      duration: animationDuration,
    );
  }
}

class UserStoryItem extends StatefulWidget {
  const UserStoryItem(
      {Key? key, required this.index, required this.setRectPoint})
      : super(key: key);

  final int index;
  final Function(Rect?) setRectPoint;
  @override
  _UserStoryItemState createState() => _UserStoryItemState();
}

class _UserStoryItemState extends State<UserStoryItem>
    with TickerProviderStateMixin {
  /// Variables
  late Animation<double> gap;
  late Animation<double> base;
  late Animation<double> reverse;
  AnimationController? animationController;
  Rect? rect;
  GlobalKey touchPoint = GlobalKey();

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    base = CurvedAnimation(parent: animationController!, curve: Curves.easeOut);
    reverse = Tween<double>(begin: 0.0, end: -1.0).animate(base);
    gap = Tween<double>(begin: 3.0, end: 0.0).animate(base)
      ..addListener(() {
        setState(() {});
      });
    animationController!.forward();
    animationController!.addListener(() {
      if (animationController!.isCompleted) {
        animationController!.repeat();
      }
    });
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        key: touchPoint,
        behavior: HitTestBehavior.opaque,
        onTapUp: (detalis) {
          var object = touchPoint.currentContext?.findRenderObject();
          var translation = object?.getTransformTo(null).getTranslation();
          var size = object?.semanticBounds.size;
          rect = Rect.fromLTWH(
              translation!.x, translation.y, size!.width, size.height);
          widget.setRectPoint(rect);
        },
        child: Hero(
          tag: "index${widget.index}",
          transitionOnUserGestures: true,
          child: Container(
            alignment: Alignment.center,
            child: RotationTransition(
              turns: base,
              child: DashedCircle(
                gapSize: gap.value,
                dashes: 20,
                // color: const Color(0xffed4634),
                child: RotationTransition(
                  turns: reverse,
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(
                          'http://m.gettywallpapers.com/wp-content/uploads/2021/03/Cool-HD-Wallpaper.jpg'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
