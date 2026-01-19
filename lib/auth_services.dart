import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';

class AuthService {

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'role': role,
      }),
    );


  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      return {
        'status': response.statusCode,
        'body': body,
      };
    } catch (e) {
      return {
        'status': 500,
        'body': {'message': 'Server error. Please try again.'},
      };
    }
  }

}
