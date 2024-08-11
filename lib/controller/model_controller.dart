import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:permission_handler/permission_handler.dart';

class ModelController {
  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> status = await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
      Permission.accessMediaLocation,
      Permission.mediaLibrary,
    ].request();
    if (status[Permission.storage]!.isDenied) {
      // Microphone permission is denied
    }
  }

  final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: 'AIzaSyAENAF3xHDy5dljlDu8VZuTo8He61ixU6k',
      generationConfig: GenerationConfig(responseMimeType: "application/json"));

  String command = '';
}
