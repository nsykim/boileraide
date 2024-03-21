import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey = 'your_openai_api_key_here';

  Future<String> sendPrompt(String promptText) async {
    const String url = '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';

    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({
            'model': 'gpt-3.5-turbo', // Or use the latest available model
            'prompt': promptText,
            'temperature': 0.5,
            'max_tokens': 100,
          }));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['choices'][0]['text'];
      } else {
        // Handle server errors
        return 'Failed to get data: ${response.statusCode}';
      }
    } catch (e) {
      // Handle network errors
      return 'Failed to connect: $e';
    }
  }
}