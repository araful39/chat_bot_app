import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String _apiKey = ''; // Replace with your actual API key

  Future<String> getGeminiResponse(String userInput) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "contents": [
          {
            "parts": [
              {"text": userInput},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['candidates'][0]['content']['parts'][0]['text'];
    } else {
      return 'Error from Gemini API: ${response.statusCode}';
    }
  }
}
