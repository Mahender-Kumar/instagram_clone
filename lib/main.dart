import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/bottom_appbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 200));
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarIconBrightness:
            Theme.of(context).colorScheme.surface.computeLuminance() > 0.5
                ? Brightness.dark
                : Brightness.light,
      ),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Instagram Clone',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.transparent,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const MyBottomAppBar()),
    );
  }
}
