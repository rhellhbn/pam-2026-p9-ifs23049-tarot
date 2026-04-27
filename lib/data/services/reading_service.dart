import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';

class ReadingService {
  static Future<Map<String, dynamic>> getReadings(
      String token, int page) async {
    final response = await http.get(
      Uri.parse("${ApiConstants.readings}?page=$page&per_page=10"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load readings");
    }
  }

  static Future<Map<String, dynamic>> generateReading(
      String token, String question, String spreadType) async {
    final response = await http.post(
      Uri.parse(ApiConstants.generateReading),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "question": question,
        "spread_type": spreadType,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? "Failed to generate reading");
    }
  }

  static Future<void> deleteReading(String token, int readingId) async {
    final response = await http.delete(
      Uri.parse("${ApiConstants.readings}/$readingId"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete reading");
    }
  }
}
