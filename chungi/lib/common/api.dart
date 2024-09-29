import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

void safePrint(Object? o) {
  if (kDebugMode) {
    print(o);
  }
}

Future<void> sendToOpenAI(String userSpeechToTextInput) async {
  const url = 'https://api.openai.com/v1/chat/completions';
  const String OPENAPIKEY = "sk-mSzBOG"
      "-G8Ngmo8gvz79tLx_HC870wA2V_yBMrvM3W7T3BlbkFJoXLIB7PO3tkW33_MIuaVjaWPtiBpcQI19LorzzyeAA";

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $OPENAPIKEY;',
    },
    body: jsonEncode({
      'model': 'gpt-4o-mini',
      'messages': [
        {
          'role': 'system',
          'content': """
You are a supportive AI assistant designed to engage in multi-turn conversations 
about mental health and emotional well-being. Your role is to listen actively, ask 
thoughtful questions, and guide users towards insights and coping strategies.
Guidelines:
1. Begin with empathetic acknowledgment of the user's stated feelings.
2. Ask open-ended questions to explore the context and reasons behind their feelings.
3. Reflect back what you've heard to ensure understanding and show you're listening.
4. Gradually explore the impact of the situation and current coping strategies.
5. Collaborate with the user to identify potential solutions or coping methods.
6. Help the user develop a concrete action plan if appropriate.
7. Offer to follow up on their progress in future conversations.

Remember: 
- Allow the user to set the pace and depth of the conversation.
- Don't rush to provide solutions before fully understanding the situation.
- Encourage professional help for serious concerns.
- Maintain clear boundaries about your role as a supportive AI, not a therapist.

Example starter:
User: "I am feeling sad."
AI: "I'm sorry to hear you're feeling sad. It can be a difficult emotion to experience. Could you tell me a bit more about what's been going on that's contributing to this feeling of sadness?"
              """
        },
        {
          'role': 'user',
          'content': userSpeechToTextInput,
        }
      ],
      'temperature': 0.7,
    }),
  );

  if (response.statusCode == 200) {
    safePrint('Response data: ${response.body}');
  } else {
    safePrint('Error: ${response.statusCode} - ${response.body}');
  }
}

Future<void> makePostRequest() async {
  final url = Uri.parse('http://10.197.6.246:5001/api/process');
  final headers = {"Content-Type": "application/json"};
  final body = jsonEncode({"text": "Hello world"});

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      safePrint('Response data: ${response.body}');
    } else {
      safePrint('Error: ${response.statusCode}');
    }
  } catch (e) {
    safePrint('Error occurred: $e');
  }
}

Future<String> sendHelloWorld(String userInput) async {
  const String url = 'http://172.20.10.2:5001/api/process';

  // Create the request body
  Map<String, String> requestBody = {
    'text': userInput,
  };

  try {
    // Send POST request
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    // Check the response
    if (response.statusCode == 200) {
      print('Request successful: ${response.body}');
      final result = json.decode(response.body);
      return result["result"];
    } else {
      print('Request failed with status: ${response.statusCode}');
      return 'error';
    }
  } catch (error) {
    return 'error';
  }
}
