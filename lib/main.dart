import 'package:fixany/controller/utils_controller.dart';
import 'package:fixany/di/service_locator.dart';
import 'package:fixany/view/camera_page/camera_page.dart';
import 'package:fixany/theme.dart';
import 'package:fixany/util.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  final utilController = getIt<UtilsController>();
  utilController.configureTts();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
