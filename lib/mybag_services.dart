import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';

class MyBagServices {
  static Future<Map<String, dynamic>> getClubs() async{
    final response = await http.get(Uri.parse('$baseUrl/my-bag'),
    headers: {
      'Accept': 'application/json'
    }
    );

    final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};

    return {
      'status': response.statusCode,
      'body': body,
    };
  }