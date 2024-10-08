import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Wrap(
        children: <Widget>[
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey[300],
            backgroundImage: CachedNetworkImageProvider(user.profileImageUrl),
          ),
          SizedBox(width: 12),
          // SizedBox(width: 10.0.w)/,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                // style: textsizeMediam12.copyWith(color: Colors.white),
              ),
              Text(
                ' 14.h',
                // style: textsize12.copyWith(
                //     color: Colors.white, fontWeight: FontWeight.w100),
              )
            ],
          )
        ],
      ),
    );
  }
}
