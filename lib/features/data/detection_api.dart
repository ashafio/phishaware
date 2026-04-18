import 'dart:convert';
import 'package:http/http.dart' as http;

class DetectionApi {
  static const String baseUrl =
      "https://phishawarebackend-production.up.railway.app";

  static Future<Map<String, dynamic>> predict(String url) async {
    final response = await http.post(
      Uri.parse("$baseUrl/predicturl"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({"url": url}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("API Error: ${response.body}");
    }
  }
}