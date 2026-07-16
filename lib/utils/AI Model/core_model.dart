import 'dart:developer';

import 'package:firebase_ai/firebase_ai.dart';

class AIModel {
  static late final GenerativeModel model;
  static late final ChatSession chat;

  static void initialize() {
    model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-3.1-flash-lite',
      tools: [Tool.urlContext()],
    );
  }

  static Future<String> generateText(String text,dynamic pdf) async {

    final prompt = [Content.multi([
      TextPart(text),
      InlineDataPart('application/pdf', pdf)
    ])];
    final response = await model.generateContent(prompt);
    log(response.text ?? 'No Response');
    return response.text ?? '';
  }
}
