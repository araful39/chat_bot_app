import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String _apiKey = 'AIzaSyCBXtI_xaGwA3bzdsh95NoLdUISWgqDQgA';

  Future<String> getGeminiResponse(List<Map<String, dynamic>> history) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash:generateContent?key=$_apiKey',
    );

    final contents =
        history.map((message) {
          return {
            "role": message['isMe'] ? "user" : "model",
            "parts": [
              {"text": message['text']},
            ],
          };
        }).toList();

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"contents": contents}),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['candidates'][0]['content']['parts'][0]['text'];
    } else {
      return 'Error from Gemini API: ${response.statusCode}';
    }
  }
}
