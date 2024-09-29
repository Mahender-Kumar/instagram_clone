import 'package:instagram_clone/models/story_model.dart';

class User {
  final int? userId;
  final String name;
  final String profileImageUrl;
  final List<Story>? stories;

  User({
      this.userId,
    required this.name,
    required this.profileImageUrl,
    this.stories,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var storiesFromJson = json['stories'] as List;
    List<Story> storyList =
        storiesFromJson.map((story) => Story.fromJson(story)).toList();

    return User(
      userId: json['user_id'],
      name: json['user_name'],
      profileImageUrl: json['profile_picture'],
      stories: storyList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': name,
      'profile_picture': profileImageUrl,
      // 'stories': stories.map((story) => story.toJson()).toList(),
    };
  }
}
