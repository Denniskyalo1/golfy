import 'dart:convert';
import 'package:http/http.dart' as http;
import 'bag_category.dart';
import 'constants.dart';

class MyBagServices {
  static Future<Map<String, dynamic>> getClubs() async {
    final response = await http.get(
      Uri.parse('$baseUrl/my-bag'),
      headers: {'Accept': 'application/json'},
    );

    final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};

    return {'status': response.statusCode, 'body': body};
  }

  static Future<List<BagCategory>> getCategories() async {
    return [
      BagCategory('Woods'),
      BagCategory('Hybrids'),
      BagCategory('Irons'),
      BagCategory('Wedges'),
      BagCategory('Putters'),
    ];
  }
}
