import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/home.dart';
import 'package:instagram_clone/screens/post.dart';
import 'package:instagram_clone/screens/profile.dart';
import 'package:instagram_clone/screens/reels.dart';
import 'package:instagram_clone/screens/search.dart';

class MyBottomAppBar extends StatefulWidget {
  const MyBottomAppBar({super.key});

  @override
  State<MyBottomAppBar> createState() => _MyBottomAppBarState();
}

class _MyBottomAppBarState extends State<MyBottomAppBar> {
  int _selectedIndex = 0;

  // List of screens to navigate
  final List<Widget> _screens = <Widget>[
    Home(),
    Search(),
    Post(),
    Reels(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          // elevation: 13,
          selectedLabelStyle: TextStyle(fontSize: 0),
          unselectedLabelStyle: TextStyle(fontSize: 0),
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          enableFeedback: false,
          backgroundColor: Colors.black,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped, // Handle tap events
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home_filled),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.movie_creation_rounded),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: CircleAvatar(
                radius: 12,
                backgroundImage: NetworkImage(
                    'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
              ),
              label: '',
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   // shape: const CircularNotchedRectangle(),
      //   // notchMargin: 5.0,
      //   clipBehavior: Clip.antiAlias,
      //   child: SizedBox(
      //     // height: kBottomNavigationBarHeight,
      //     child: Row(
      //       mainAxisSize: MainAxisSize.min,
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: <Widget>[
      //         IconButton(
      //           icon: const Icon(Icons.home),
      //           onPressed: () {
      //             setState(() {});
      //           },
      //         ),
      //         IconButton(
      //           icon: const Icon(Icons.search),
      //           onPressed: () {
      //             setState(() {});
      //           },
      //         ),
      //         IconButton(
      //           icon: const Icon(Icons.favorite_border_outlined),
      //           onPressed: () {
      //             setState(() {});
      //           },
      //         ),
      //         IconButton(
      //           icon: const Icon(Icons.account_circle_outlined),
      //           onPressed: () {
      //             setState(() {});
      //           },
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
