import 'package:fixany/camera/camera_function.dart';
import 'package:fixany/controller/model_controller.dart';
import 'package:fixany/controller/utils_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingleton(await SharedPreferences.getInstance());
  getIt.registerSingleton(CameraFunction());
  getIt.registerSingleton(ModelController());
  getIt.registerSingleton(UtilsController());
}
