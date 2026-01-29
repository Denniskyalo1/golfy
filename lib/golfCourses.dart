
import 'package:flutter/material.dart';
import 'package:golfy/constants.dart';
import 'course_services.dart';

class GolfCourses extends StatefulWidget {
  const GolfCourses({super.key});

  @override
  State<GolfCourses> createState() => _GolfCoursesState();
}

class _GolfCoursesState extends State<GolfCourses> {
  int _currentPage = 1;
  int _lastPage = 1;
  bool _isRefreshing = false;

  final Map<int, List<dynamic>> _pagesCache = {};

  Future<void> _fetchPage(int page) async {
    try {
      final response = await CourseServices.getCourses(page: page);
      if (response != null && response['data'] != null) {
        _pagesCache[page] = response['data'];
        _lastPage = response['meta']['last_page'] ?? 1;
      }
    } catch (e) {
      debugPrint('Error fetching page $page: $e');
      rethrow;
    }
  }

  Future<void> _refreshCurrentPage() async {
    setState(() => _isRefreshing = true);
    try {
      _pagesCache.remove(_currentPage);
      await _fetchPage(_currentPage);
    } finally {
      setState(() => _isRefreshing = false);
    }
  }

  void _goToNextPage() {
    if (_currentPage < _lastPage) {
      setState(() => _currentPage++);
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 1) {
      setState(() => _currentPage--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: const TopBar(
        title: 'C O U R S E S',
        backgroundColor: Colors.transparent,
        showBackButton: true,
      ),
      body: FutureBuilder<void>(
        key: ValueKey(_currentPage),
        future: _pagesCache.containsKey(_currentPage)
            ? Future.value() // Already cached
            : _fetchPage(_currentPage),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !_pagesCache.containsKey(_currentPage)) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading courses: ${snapshot.error}'));
          }

          final courses = _pagesCache[_currentPage] ?? [];

          if (courses.isEmpty) {
            return const Center(child: Text('No courses available'));
          }

          return RefreshIndicator(
            onRefresh: _refreshCurrentPage,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return _buildCourseCard(
                        course: course,
                        height: height,
                        width: width,
                      );
                    },
                  ),
                ),
                _buildPaginationControls(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseCard({
    required Map<String, dynamic> course,
    required double height,
    required double width,
  }) {
    final imageUrl = course['cover_image'] as String?;
    final hasValidImage = imageUrl != null && imageUrl.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: height * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: hasValidImage
              ? NetworkImage(imageUrl)
              : const AssetImage('images/course.jpg') as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: height * 0.04,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course['name'] ?? 'Unknown Course',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  course['location']?['city'] ?? 'Unknown City',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: height * 0.02,
                  ),
                ),
              ],
            ),
          ),

          // Action buttons
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/selectedCourse',
                        arguments: course['id'],
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Preview',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Play Golf',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: _currentPage > 1 ? Colors.blueAccent : Colors.grey,
            ),
            onPressed: _currentPage > 1 ? _goToPreviousPage : null,
          ),
          Text(
            'Page $_currentPage of $_lastPage',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: _currentPage < _lastPage ? Colors.blueAccent : Colors.grey,
            ),
            onPressed: _currentPage < _lastPage ? _goToNextPage : null,
          ),
        ],
      ),
    );
  }
}
