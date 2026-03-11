import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';

class LikeCourseService {
  LikeCourseService._();

  static Future<Map<String, dynamic>> likeCourse({
    required int courseId,
    required String token,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse('$baseUrl/courses/$courseId/toggleLike'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to like/unlike course: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getLikedCourses({
    required String token,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('$baseUrl/courses/my-liked-courses'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load liked courses: ${response.body}');
    }
  }
}