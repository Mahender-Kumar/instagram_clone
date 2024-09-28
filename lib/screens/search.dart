import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Form(
          child: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[800],
              contentPadding: EdgeInsets.all(0),
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ),
    );
  }
}
