import 'package:fixany/camera/camera_function.dart';
import 'package:get_it/get_it.dart';
final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingleton(CameraFunction());
}