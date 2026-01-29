import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';

class CourseServices {
  CourseServices._();

  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };


  static Future<Map<String, dynamic>> getCourses({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/courses?page=$page'),
        headers: _jsonHeaders,
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'data': decoded['data'],
          'meta': decoded['meta'],
        };
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load courses: $e');
    }
  }


  static Future<String?> getPlaceId(String courseName) async {
    try {
      final response = await http.post(
        Uri.parse('https://places.googleapis.com/v1/places:searchText'),
        headers: _jsonHeaders,
        body: jsonEncode({
          'query': courseName,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return decoded['place_id'] as String?;
      }

      return null;
    } catch (e) {
      print('Error fetching place ID: $e');
      return null;
    }
  }


  static Future<Map<String, dynamic>?> getSelectedCourse(int courseId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/courses/$courseId'),
        headers: _jsonHeaders,
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return decoded['data'] as Map<String, dynamic>?;
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load course: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load course: $e');
    }
  }
}