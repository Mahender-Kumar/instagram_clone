
import 'package:instagram_clone/models/story.dart';
 

class User {
  final int userId;
  final String userName;
  final String profilePicture;
  final List<Story> stories;

  User({
    required this.userId,
    required this.userName,
    required this.profilePicture,
    required this.stories,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var storiesFromJson = json['stories'] as List;
    List<Story> storyList = storiesFromJson.map((story) => Story.fromJson(story)).toList();

    return User(
      userId: json['user_id'],
      userName: json['user_name'],
      profilePicture: json['profile_picture'],
      stories: storyList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'profile_picture': profilePicture,
      'stories': stories.map((story) => story.toJson()).toList(),
    };
  }
}
