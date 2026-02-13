import 'package:flutter/material.dart';
import 'package:golfy/constants.dart';
import 'package:provider/provider.dart';
import 'providers/courses_provider.dart';

class GolfCourses extends StatefulWidget {
  const GolfCourses({super.key});

  @override
  State<GolfCourses> createState() => _GolfCoursesState();
}

class _GolfCoursesState extends State<GolfCourses> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar:  TopBar(
        title: 'C O U R S E S',
        backgroundColor: Theme.of(context).colorScheme.primary,
        showBackButton: true,
        route: '/homePage',
      ),
      body: Consumer<CoursesProvider>(
        builder: (context, coursesProvider, child) {
          return FutureBuilder<void>(
            key: ValueKey(coursesProvider.currentPage),
            future: coursesProvider.pagesCache.containsKey(coursesProvider.currentPage)
                ? Future.value()
                : coursesProvider.fetchPage(coursesProvider.currentPage),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting && !coursesProvider.pagesCache.containsKey(coursesProvider.currentPage)) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error loading courses: ${snapshot.error}'));
              }

              final courses = coursesProvider.pagesCache[coursesProvider.currentPage] ?? [];

              if (courses.isEmpty) {
                return const Center(child: Text('No courses available'));
              }

              return RefreshIndicator(
                onRefresh: coursesProvider.refreshCurrentPage,
                color: Theme.of(context).colorScheme.onSurface,
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
                            isDark: Theme.of(context).brightness == Brightness.dark,
                          );
                        },
                      ),
                    ),
                    _buildPaginationControls(coursesProvider),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCourseCard({
    required Map<String, dynamic> course,
    required double height,
    required double width,
    required bool isDark,
  }) {
    final imageUrl = course['cover_image'] as String?;
    final hasValidImage = imageUrl != null && imageUrl.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: height * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark? Theme.of(context).colorScheme.onSurface : Colors.transparent,
        ),
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
                    color: isDark ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.primary,
                    fontSize: height * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  course['location']?['city'] ?? 'Unknown City',
                  style: TextStyle(
                    color: isDark ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7) : Theme.of(context).colorScheme.primary.withOpacity(0.7),
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
                      backgroundColor: isDark?  Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary ,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: isDark?  Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),

                    ),
                    child:  Text(
                      'Preview',
                      style: TextStyle(
                        color: isDark ?  Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
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
                        side: BorderSide(
                          color: Colors.blueAccent,
                        )
                      ),
                    ),
                    child:  Text(
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

  Widget _buildPaginationControls(CoursesProvider coursesProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: coursesProvider.currentPage > 1 ? Colors.blueAccent : Colors.grey,
            ),
            onPressed: coursesProvider.currentPage > 1 ? coursesProvider.goToPreviousPage : null,
          ),
          Text(
            'Page ${coursesProvider.currentPage} of ${coursesProvider.lastPage}',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: coursesProvider.currentPage < coursesProvider.lastPage ? Colors.blueAccent : Colors.grey,
            ),
            onPressed: coursesProvider.currentPage < coursesProvider.lastPage ? coursesProvider.goToNextPage : null,
          ),
        ],
      ),
    );
  }
}