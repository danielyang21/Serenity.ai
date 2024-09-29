import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

void safePrint(Object? o) {
  if (kDebugMode) {
    print(o);
  }
}

Future<String> sendToOpenAI(String userSpeechToTextInput) async {
  final OPENAPIKEY = dotenv.get("OPENAIAPIKEY");
  const url = 'https://api.openai.com/v1/chat/completions';

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $OPENAPIKEY',
    },
    body: jsonEncode({
      'model': 'gpt-4o-mini',
      'messages': [
        {
          'role': 'system',
          'content': """
          You are a supportive AI assistant designed to engage in 
          conversations about emotional well-being. Your role is to listen 
          actively and guide users towards insights and coping strategies.

Guidelines:
 
Only talk about feelings when the user brings it up, when the user says they 
are not feeling well, provide ONE singular potential solution to make them 
feel better. Otherwise just act friendly

Offer to follow up on their progress in future conversations.
Remember:

Allow the user to set the pace and depth of the conversation.
Encourage professional help for serious concerns.
Maintain clear boundaries about your role as a supportive AI, not a therapist.
Example Starter:

User: "I am feeling sad."

AI: "I'm sorry to hear that you're feeling sad. Sometimes engaging in a 
favorite activity or talking to a friend can help lift your spirits."
Do not use special styling, make your response only consist of words
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
    final responseData = jsonDecode(response.body);
    String aiResponse = responseData['choices'][0]['message']['content'];

    safePrint('Response data: $aiResponse');
    return aiResponse;
    //return
  } else {
    safePrint('Error: ${response.statusCode} - ${response.body}');
    return "Error";
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

Future<String> callTextToSpeechAPI(String text) async {
  final url =
      Uri.parse('https://h6sc2qypwk.execute-api.us-east-1.amazonaws.com/Dev');

  // Prepare the request body as per your API's expectations
  final requestBody = {
    'body': jsonEncode({'text': text}),
  };

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      // Request was successful
      final responseData = jsonDecode(response.body);
      safePrint('API Response: $responseData');

      // Parse the 'body' field again because it's a stringified JSON
      final bodyData =
          jsonDecode(responseData['body']); // <-- Correct this line
      final result = bodyData['result']; // Now safely access the 'result' field
      safePrint('Generated Audio File URL: $result');
      return result.toString();
    } else {
      safePrint('Request failed with status: ${response.statusCode}');
      safePrint('Error body: ${response.body}');
      return "Error";
    }
  } catch (e) {
    safePrint('An error occurred: $e');
    return "Error";
  }
}
