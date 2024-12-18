import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String _apiKey = dotenv.env['API_KEY_OPEN_AI'] ?? ''; 

  Future<String> generateContent(String prompt) async {
    const String apiUrl = "https://api.openai.com/v1/chat/completions";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiKey",
      },
      body: jsonEncode({
        "model": "gpt-4o-mini", 
        "messages": [
          {
            "role": "system",
            "content":
                "You are a helpful assistant that generates news content."
          },
          {
            "role": "user",
            "content": prompt,
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['choices'][0]['message']['content'].trim();
    } else {
      throw Exception("Failed to generate content: ${response.body}");
    }
  }
}
