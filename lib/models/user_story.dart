import 'package:instagram_clone/models/story_model.dart';
import 'package:instagram_clone/models/user_model.dart';

class UserStoryList {
  List<Story> story;
  User user;

  UserStoryList({required this.story, required this.user});
}