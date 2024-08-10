import 'package:fixany/di/service_locator.dart';
import 'package:fixany/model/command_model.dart';
import 'package:fixany/services/database_helper.dart';
import 'package:fixany/view/camera_page/camera_page.dart';
import 'package:fixany/theme.dart';
import 'package:fixany/util.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();

  DatabaseHelper commanddb = DatabaseHelper.instance;

  commanddb.getAll().then((value) {
    if (value.isEmpty) {
      commanddb.insert(CommandModel('Default Command',
          'Analyze the broken part, and list the step to fix it', 1));
      commanddb.insert(CommandModel(
          'Google Cookbook ',
          'Analyze the ingredient , and create receipe with that ingredient',
          0));
    } else {}
  }).then((onValue) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: theme.dark(),
      debugShowCheckedModeBanner: false,
      home: const CameraPage(),
    );
  }
}
