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
    const SearchScreen(),
    const AddPostScreen(),
    const Reels(),
    const ProfileScreen(),
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
          selectedLabelStyle: const TextStyle(fontSize: 0),
          unselectedLabelStyle: const TextStyle(fontSize: 0),
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          enableFeedback: false,
          backgroundColor: Colors.black,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped, // Handle tap events
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_sharp),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search_sharp),
              activeIcon: Icon(Icons.search_rounded),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              activeIcon: Icon(
                Icons.add_box,
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              activeIcon: Icon(Icons.movie_creation_rounded),
              icon: Icon(Icons.movie_creation_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: const CircleAvatar(
                radius: 12,
                backgroundImage: NetworkImage(
                    'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
              ),
              activeIcon: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(
                      'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
                ),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
