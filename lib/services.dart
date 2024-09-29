import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:http/http.dart' as http;
 
final userProvider = FutureProvider<List<User>>((ref) async {
  final response = await http.get(Uri.parse('https://ixifly.in/flutter/task2'));

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    List<dynamic> jsonData = jsonResponse['data'];
    return jsonData.map((user) => User.fromJson(user)).toList();
  } else {
    throw Exception('Failed to load users');
  }
});
