import 'package:google_generative_ai/google_generative_ai.dart';

class ModelController {

  final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: 'AIzaSyAENAF3xHDy5dljlDu8VZuTo8He61ixU6k',
      generationConfig: GenerationConfig(responseMimeType: "application/json"));

  String command = '';
}
