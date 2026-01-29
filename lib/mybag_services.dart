import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'bag_category.dart';
import 'constants.dart';

class MyBagServices {
  MyBagServices._();

  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static  final List<BagCategory> _categories = [
    BagCategory('Woods'),
    BagCategory('Hybrids'),
    BagCategory('Irons'),
    BagCategory('Wedges'),
    BagCategory('Putters'),
  ];


  static Future<Map<String, dynamic>> getClubs({String? token}) async {
    try {
      final headers = token != null
          ? {..._jsonHeaders, 'Authorization': 'Bearer $token'}
          : _jsonHeaders;

      final response = await http.get(
        Uri.parse('$baseUrl/my-bag'),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e, 'Get clubs');
    }
  }

  static List<BagCategory> getCategories() {
    return _categories;
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
    debugPrint('$operation error: $error');
    return {
      'status': 500,
      'body': {'message': 'Server error. Please try again.'},
    };
  }
}