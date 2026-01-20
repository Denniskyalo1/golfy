import 'package:flutter/material.dart';
import 'package:golfy/constants.dart';
import 'course_services.dart';

class GolfCourses extends StatefulWidget {
  const GolfCourses({super.key});

  @override
  State<GolfCourses> createState() => _GolfCoursesState();
}

class _GolfCoursesState extends State<GolfCourses> {
  int currentPage = 1;
  int lastPage = 1;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: TopBar(
        title: 'C O U R S E S',
        backgroundColor: Colors.transparent,
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<Map<String, dynamic>>(
          future: CourseServices.getCourses(page: currentPage),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData) {
              print('Error: ${snapshot.error}');
              print('Stack trace: ${snapshot.stackTrace}');
              return const Center(child: Text('Error loading courses'));
            }

            final courses = snapshot.data!['data'] as List<dynamic>;
            final meta = snapshot.data!['meta'];

            lastPage = meta['last_page'];

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      final imageUrl = course['cover_image'] as String?;
                      print(imageUrl);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        height: height * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: imageUrl != null && imageUrl.isNotEmpty
                                ? NetworkImage(imageUrl) as ImageProvider
                                : const AssetImage('images/course.jpg') as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
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
                                    course['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: height * 0.035,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    course['location']['city'],
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: height * 0.02,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// BUTTONS
                            Positioned(
                              bottom: 20,
                              left: 20,
                              right: 20,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor:
                                        Colors.blueGrey[300],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
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
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
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
                    },
                  ),
                ),

                /// PAGINATION
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon:  Icon(
                          Icons.arrow_back_ios_new,
                        color: currentPage > 1
                          ? Colors.blueAccent
                          : Colors.grey,
                      ),
                      onPressed: currentPage > 1
                          ? () => setState(() => currentPage--)
                          : null,
                    ),
                    Text('Page $currentPage of $lastPage'),
                    IconButton(
                      icon:  Icon(
                          Icons.arrow_forward_ios,
                        color: currentPage < lastPage
                          ? Colors.blueAccent
                            : Colors.grey,
                      ),
                      onPressed: currentPage < lastPage
                          ? () => setState(() => currentPage++)
                          : null,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
