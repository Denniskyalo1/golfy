import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';

class CourseServices {
  static Future<List<dynamic>> getCourses() async {
    final response = await http.get(
      Uri.parse('$baseUrl/courses'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['data'];
    } else {
      throw Exception('Failed to load courses');
    }
  }

  static Future<String?> getPlaceId(String courseName) async {
    final response = await http.post(
      Uri.parse('https://places.googleapis.com/v1/places:searchText'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'query': courseName,
      }),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['place_id'];
    }

    return null;
  }

}
