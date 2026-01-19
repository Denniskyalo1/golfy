import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:golfy/constants.dart';
import 'package:golfy/place_services.dart';
import 'course_services.dart';
import 'place_services.dart';

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
      backgroundColor: Colors.blueGrey[100],
      appBar: TopBar(
        title: 'C O U R S E S',
        backgroundColor: Colors.transparent,
        showBackButton: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<dynamic>>(
          future: CourseServices.getCourses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading courses'));
            }

            final courses = snapshot.data!;

            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<String?>(
                    future: PlacesService().getCoursePhotoUrl(
                      course['name'],
                      maxWidth: 800,
                    ),
                    builder: (context, photoSnapshot) {
                      ImageProvider imageProvider;

                      if (photoSnapshot.connectionState == ConnectionState.waiting) {
                        // Show placeholder while loading
                        imageProvider = const AssetImage('images/course.jpg');
                      } else if (photoSnapshot.hasData && photoSnapshot.data != null) {
                        // Use network image if available
                        imageProvider = NetworkImage(photoSnapshot.data!);
                      } else {
                        // Fallback to asset image if no photo found
                        imageProvider = const AssetImage('images/course.jpg');
                      }

                      return Container(
                        height: height * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {
                              // Handle image load error silently
                              print('Error loading image: $exception');
                            },
                          ),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                                  child: Text(
                                    course['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: height * 0.035,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                                  child: Text(
                                    course['location']['city'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: height * 0.02,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 20,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: width * 0.05),
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        fixedSize: Size(width * 0.27, height * 0.055),
                                        side: BorderSide(color: Colors.blueGrey[300]!, width: 1.5),
                                        backgroundColor: Colors.blueGrey[300],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        'Preview',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: width * 0.05),
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        fixedSize: Size(width * 0.45, height * 0.055),
                                        side: const BorderSide(color: Colors.blueAccent, width: 1.5),
                                        backgroundColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        'Play Golf',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
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
                );
              },
            );
          },
        ),
      ),
    );
  }
}