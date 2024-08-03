import 'package:google_generative_ai/google_generative_ai.dart';

class ModelController {
  final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: '',
      generationConfig: GenerationConfig(responseMimeType: "application/json"));
}
