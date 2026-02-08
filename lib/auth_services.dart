import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';

class AuthService {
  AuthService._();

  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const Map<String, dynamic> _defaultErrorResponse = {
    'status': 500,
    'body': {'message': 'Server error. Please try again.'},
  };


  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: _jsonHeaders,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'role': role,
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e, 'Registration');
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: _jsonHeaders,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e, 'Login');
    }
  }



  static Map<String, dynamic> _handleResponse(http.Response response) {
    final body = response.body.isNotEmpty
        ? jsonDecode(response.body) as Map<String, dynamic>
        : <String, dynamic>{};

    return {
      'status': response.statusCode,
      'body': body,
    };
  }

  static Map<String, dynamic> _handleError(Object error, String operation) {
    return Map<String, dynamic>.from(_defaultErrorResponse);
  }

  static Future<Map<String, dynamic>> verifyOTP({
    required String otp,
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-email'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email':email,
          'otp': otp,
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