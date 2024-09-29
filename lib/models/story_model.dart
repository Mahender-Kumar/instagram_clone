import 'package:instagram_clone/models/user_model.dart';

enum MediaType { image, video }

class Story {
  final int? storyId;
  final String url;
  final MediaType media; // Could be "image" or "video"
  final DateTime? timestamp;
  final String? text;
  final String? textDescription;
  final Duration? duration;
  // final User user;

  Story(
      {this.storyId,
      required this.url,
      required this.media,
      this.timestamp,
      this.text,
      this.textDescription,
      // required this.user,
      this.duration = const Duration(seconds: 5)});

  factory Story.fromJson(Map<String, dynamic> json) {
    // print(json['timestamp'].runtimeType);
    return Story(
      storyId: json['story_id'],
      url: json['media_url'],
      media: json['media_type'] == null
          ? json['media_url'].toString().split('.').last.trim().toLowerCase() ==
                  'mp4'
              ? MediaType.video
              : MediaType.image
          : json['media_type'] == 'image'
              ? MediaType.image
              : MediaType.video,
      timestamp: parseDateString(json['timestamp']),
      text: json['text'],
      textDescription: json['text_description'],
      // user: User(
      //   userId: json['user_id']??0,
      //   name: json['user_name']??'',
      //   profileImageUrl: json['profile_picture']??'',
      // )
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'story_id': storyId,
      'media_url': url,
      'media_type': media,
      'timestamp': timestamp?.toIso8601String(),
      'text': text,
      'text_description': textDescription,
    };
  }
}

DateTime parseDateString(String dateString) {
  // Split the date and time
  List<String> dateTimeParts = dateString.split('T');

  // Ensure we have both date and time
  if (dateTimeParts.length != 2) {
    throw FormatException(
        'Invalid date format: expected "YYYY-MM-DDTHH:MM:SS"');
  }

  String datePart = dateTimeParts[0];
  String timePart = dateTimeParts[1];

  // Split date and ensure zero padding
  List<String> dateParts = datePart.split('-');
  if (dateParts.length != 3) {
    throw FormatException('Invalid date format: expected "YYYY-MM-DD"');
  }

  String year = dateParts[0];
  String month = dateParts[1];
  String day = dateParts[2];

  // Validate year, month, and day
  int yearInt = int.tryParse(year) ?? 1; // Default to 1 if parsing fails
  int monthInt = int.tryParse(month) ?? 1; // Default to 1 if parsing fails
  int dayInt = int.tryParse(day) ?? 1; // Default to 1 if parsing fails

  // Adjust values to be at least 1
  yearInt = yearInt < 1 ? 1 : yearInt;
  monthInt = monthInt < 1 ? 1 : monthInt;
  dayInt = dayInt < 1 ? 1 : dayInt;

  // Check for valid month
  if (monthInt < 1 || monthInt > 12) {
    throw FormatException('Invalid month: $month');
  }

  // Get the last day of the month
  int maxDays =
      DateTime(yearInt, monthInt + 1, 0).day; // Get last day of the month

  if (dayInt < 1 || dayInt > maxDays) {
    throw FormatException('Invalid day: $day for month: $month');
  }

  // Split time and ensure zero padding
  List<String> timeParts = timePart.split(':');
  String hour = timeParts[0].padLeft(2, '0'); // Ensure two digits
  String minute = timeParts.length > 1
      ? timeParts[1].padLeft(2, '0')
      : '00'; // Ensure two digits
  String second = timeParts.length > 2
      ? timeParts[2].padLeft(2, '0')
      : '00'; // Default to zero if not present

  // Construct the corrected date string
  String correctedDateString =
      '$yearInt-${monthInt.toString().padLeft(2, '0')}-${dayInt.toString().padLeft(2, '0')}T$hour:$minute:$second';

  try {
    DateTime dateTime = DateTime.parse(correctedDateString);
    return dateTime;
  } catch (e) {
    throw FormatException('Error parsing date: $e');
  }
}
