import 'package:flutter/material.dart';
import 'package:golfy/like_course_services.dart';

class LikeCourseProvider extends ChangeNotifier {
  List<int> likedCourseIds = [];
  String? error;
  bool isLoading = false;

  /// Fetch liked courses for the authenticated user
  Future<void> fetchLikedCourses(String token) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await LikeCourseService.getLikedCourses(token: token);

      likedCourseIds = List<int>.from(response['liked_course_ids']);
    } catch (e) {
      error = e.toString();
      print(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle like/unlike for a course
  Future<void> toggleLike(int courseId, String token) async {
    try {
      error = null;
      final _ = await LikeCourseService.likeCourse(
        courseId: courseId,
        token: token,
      );


      // Update likedCourseIds locally
      if (likedCourseIds.contains(courseId)) {
        likedCourseIds.remove(courseId);
      } else {
        likedCourseIds.add(courseId);
      }

      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  //Check if a course is liked
  bool isLiked(int courseId) {
    return likedCourseIds.contains(courseId);
  }
}