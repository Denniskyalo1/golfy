import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class PlacesService {
  static String placeIdKey(String courseName) =>
      'place_id_${courseName.toLowerCase()}';

  Future<String> getPlaceId(String courseName) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = placeIdKey(courseName);

    final cachedPlaceId = prefs.getString(cacheKey);
    if (cachedPlaceId != null) {
      return cachedPlaceId;
    }

    final response = await http.post(
      Uri.parse('https://places.googleapis.com/v1/places:searchText'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Goog-Api-Key': apiKey,
        'X-Goog-FieldMask': 'places.id',
      },
      body: jsonEncode({
        'textQuery': courseName,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch Place ID');
    }

    final data = jsonDecode(response.body);

    if (data['places'] == null || data['places'].isEmpty) {
      throw Exception('No places found for: $courseName');
    }

    final placeId = data['places'][0]['id'];

    await prefs.setString(cacheKey, placeId);

    return placeId;
  }

  // Method to fetch photo names only
  Future<List<String>> getPhotoNames(String courseName) async {
    final placeId = await getPlaceId(courseName);

    final response = await http.get(
      Uri.parse(
          'https://places.googleapis.com/v1/places/$placeId'
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Goog-Api-Key': apiKey,
        'X-Goog-FieldMask': 'photos'
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch place details');
    }

    final data = jsonDecode(response.body);

    if (data['photos'] == null || data['photos'].isEmpty) {
      return [];
    }

    final photoNames = (data['photos'] as List)
        .map((photo) => photo['name'] as String)
        .toList();

    return photoNames;
  }

  String getPhotoUrl(String photoName, {int maxWidth = 400}) {
    return 'https://places.googleapis.com/v1/$photoName/media?maxWidthPx=$maxWidth&key=$apiKey';
  }

  Future<String?> getCoursePhotoUrl(String courseName, {int maxWidth = 400}) async {
    try {
      final photoNames = await getPhotoNames(courseName);
      if (photoNames.isEmpty) {
        return null;
      }
      return getPhotoUrl(photoNames[0], maxWidth: maxWidth);


    } catch (e) {
      print('Error getting course photo: $e');
      return null;
    }
  }
}