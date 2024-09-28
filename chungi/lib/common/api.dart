import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String OpenAIAPIKEY =
    "sk-mSzBOG-G8Ngmo8gvz79tLx_HC870wA2V_yBMrvM3W7T3BlbkFJoXLIB7PO3tkW33_MIuaVjaWPtiBpcQI19LorzzyeAA";

Future<void> postToOpenAI(String userSpeechToTextInput) async {
  const url = 'https://api.openai.com/v1/chat/completions';
  const apiKey = OpenAIAPIKEY; // Replace with your actual API key

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: jsonEncode({
      'model': 'gpt-4o-mini',
      'messages': [
        {
          'role': 'user',
          'content': userSpeechToTextInput,
        }
      ],
      'temperature': 0.7,
    }),
  );

  if (response.statusCode == 200) {
    if (!kReleaseMode) {
      print('Response data: ${response.body}');
    }
  } else {
    print('Error: ${response.statusCode} - ${response.body}');
  }
}
