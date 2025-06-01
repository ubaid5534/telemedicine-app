import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // For web development
  static const String baseUrl = 'http://localhost:8000';

  Future<Map<String, dynamic>> analyzeSymptoms(String symptoms) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/analyze-symptoms'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'symptoms': symptoms}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to analyze symptoms');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<List<Map<String, dynamic>>> searchDoctors({
    required String location,
    required String specialization,
    required int radius,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/search-doctors'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'location': location,
          'specialization': specialization,
          'radius': radius,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to search doctors');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }
} 