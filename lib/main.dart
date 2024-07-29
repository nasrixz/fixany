import 'package:fixany/di/service_locator.dart';
import 'package:fixany/view/camera_page/camera_page.dart';
import 'package:fixany/theme.dart';
import 'package:fixany/util.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      debugShowCheckedModeBanner: false,
      home: const CameraPage(),
    );
  }
}
