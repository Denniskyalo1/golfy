import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/selectedCourse_provider.dart';

class SelectedCourse extends StatefulWidget {
  const SelectedCourse({super.key});

  @override
  State<SelectedCourse> createState() => _SelectedCourseState();
}

class _SelectedCourseState extends State<SelectedCourse> {
  late int _courseId;
  bool _hasLoadedCourse = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasLoadedCourse) {
      _courseId = ModalRoute.of(context)!.settings.arguments as int;
      context.read<SelectedCourseProvider>().loadCourse(_courseId);
      _hasLoadedCourse = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer<SelectedCourseProvider>(
      builder: (context, selectedCourseProvider, child) {
        if (selectedCourseProvider.isLoading) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (selectedCourseProvider.error != null || selectedCourseProvider.course == null) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(selectedCourseProvider.error ?? 'Course not found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, height, width, selectedCourseProvider),
                _buildCourseDetails(width, selectedCourseProvider),
                const Divider(),
                _buildInformationSection(width, height, selectedCourseProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, double height, double width, SelectedCourseProvider selectedCourseProvider) {
    final coverImage = selectedCourseProvider.course!['cover_image'] as String?;
    final hasValidImage = coverImage != null && coverImage.isNotEmpty;

    return Stack(
      children: [
        Container(
          height: height * 0.25,
          width: width,
          decoration: BoxDecoration(
            image: hasValidImage
                ? DecorationImage(
              image: NetworkImage(coverImage),
              fit: BoxFit.cover,
            )
                : const DecorationImage(
              image: AssetImage('images/course.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: width * 0.13,
          left: width * 0.05,
          child: Container(
            height: width * 0.1,
            width: width * 0.1,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 22,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseDetails(double width, SelectedCourseProvider selectedCourseProvider) {
    final location = selectedCourseProvider.course!['location'] as Map<String, dynamic>?;
    final city = location?['city'] ?? '';
    final country = location?['country'] ?? '';

    return Padding(
      padding: EdgeInsets.all(width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectedCourseProvider.course!['name'] ?? '',
            style: TextStyle(
              fontSize: width * 0.07,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "$city, $country",
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: width * 0.05,
            ),
          ),
          SizedBox(height: width * 0.06),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildIconButton(Icons.call),
                  _buildIconButton(Icons.directions),
                  _buildIconButton(Icons.web),
                  _buildIconButton(Icons.calendar_month),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                  size: 26,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInformationSection(double width, double height, SelectedCourseProvider selectedCourseProvider) {
    return Padding(
      padding: EdgeInsets.all(width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Information',
            style: TextStyle(
              fontSize: width * 0.06,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: width * 0.04),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(
                icon: Icons.star,
                value: selectedCourseProvider.course!['rating']?.toString() ?? '0',
                label: '${selectedCourseProvider.course!['reviews_count']?.toString() ?? '0'} reviews',
                width: width,
              ),
              _buildDivider(height),
              _buildInfoItem(
                icon: Icons.favorite,
                value: selectedCourseProvider.course!['likes_count']?.toString() ?? '0',
                label: 'Likes',
                width: width,
                iconColor: Colors.red,
              ),
              _buildDivider(height),
              _buildInfoItem(
                icon: Icons.golf_course,
                value: selectedCourseProvider.course!['holes']?.toString() ?? '18',
                label: 'Holes',
                width: width,
              ),
            ],
          ),
          SizedBox(height: width * 0.06),
          const Text(
            'The Karen Country Club is a family-oriented club, founded in 1937, and prides itself on being one of the oldest golf clubs in Kenya.\n\n'
                'A large part of the 18-hole course was built on the former coffee estate developed by the Danish pioneer Karen Blixen, whose life and times were depicted in the lyrical film "Out of Africa". '
                'Indeed, the shade trees from her coffee plantation still dominate parts of the golf course, more than eighty years after they were planted.\n\n'
                'The course is superbly maintained, with greens built to Professional Golf Association (PGA) standards. '
                'The Club has hosted the prestigious Barclays Kenya Open for three consecutive years. '
                'Despite Nairobi’s temperate climate, golfers can enjoy play 365 days a year in comfort.\n\n'
                'The setting of the course is serene, with the Ngong Hills as a backdrop, a rich variety of trees, indigenous forest, flowering shrubs, and fauna.',
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.grey),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String value,
    required String label,
    required double width,
    Color iconColor = Colors.black,
  }) {
    return SizedBox(
      width: width * 0.25,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: width * 0.05),
              const SizedBox(width: 4),
              Text(
                value,
                style: TextStyle(fontSize: width * 0.045),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: width * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(double height) {
    return Container(
      height: height * 0.06,
      width: 1,
      color: Colors.grey[300],
    );
  }
}