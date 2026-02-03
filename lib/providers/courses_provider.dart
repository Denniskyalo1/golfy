import 'package:flutter/material.dart';
import '../course_services.dart';

class CoursesProvider extends ChangeNotifier {
  int currentPage = 1;
  int lastPage = 1;
  bool isRefreshing = false;

  final Map<int, List<dynamic>> pagesCache = {};

  Future<void> fetchPage(int page) async {
    try {
      final response = await CourseServices.getCourses(page: page);
      if (response['data'] != null) {
        pagesCache[page] = response['data'];
        lastPage = response['meta']['last_page'] ?? 1;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching page $page: $e');
      rethrow;
    }
  }

  Future<void> refreshCurrentPage() async {
    isRefreshing = true;
    notifyListeners();
    try {
      pagesCache.remove(currentPage);
      await fetchPage(currentPage);
    } finally {
      isRefreshing = false;
      notifyListeners();
    }
  }

  void goToNextPage() {
    if (currentPage < lastPage) {
      currentPage++;
      notifyListeners();
    }
  }

  void goToPreviousPage() {
    if (currentPage > 1) {
      currentPage--;
      notifyListeners();
    }
  }
}