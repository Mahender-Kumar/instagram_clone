import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Row(
          children: [
            Icon(Icons.lock_outline),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'mahe',
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                LayoutBuilder(builder: (context, constraint) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              "https://www.w3schools.com/w3images/avatar2.png",
                            ),
                            radius: 40,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: constraint.maxWidth * 0.2,
                              ),
                              child: const Text('hi i am on insta'))
                        ],
                      ),
                      const Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('1'),
                            Text('posts'),
                          ],
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text('1'),
                            Text('followers'),
                          ],
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text('1'),
                            Text('following'),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'num'.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: const Text(
            'label',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
