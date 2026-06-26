import 'package:firebase_ai/firebase_ai.dart';

class AIModel {
  static late final GenerativeModel model;
  static late final ChatSession chat;

  static void initialize() {
    model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-3.1-flash',
    );
  }

  static Future<String> generateText(String text) async {
    final prompt = [Content.text(text)];
    final response = await model.generateContent(prompt);
    return response.text ?? '';
  }
}
