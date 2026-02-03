import 'package:flutter/material.dart';
import '../course_services.dart';

class SelectedCourseProvider extends ChangeNotifier {
  Map<String, dynamic>? course;
  bool isLoading = true;
  String? error;

  Future<void> loadCourse(int courseId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final courseData = await CourseServices.getSelectedCourse(courseId);
      course = courseData;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = 'Failed to load course details';
      isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    course = null;
    isLoading = true;
    error = null;
  }
}