import 'package:flutter/material.dart';
import 'course_services.dart';

class SelectedCourse extends StatefulWidget {
  const SelectedCourse({super.key});

  @override
  State<SelectedCourse> createState() => _SelectedCourseState();
}

class _SelectedCourseState extends State<SelectedCourse> {
  late int _courseId;
  Map<String, dynamic>? _course;
  bool _isLoading = true;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isLoading) {
      _courseId = ModalRoute.of(context)!.settings.arguments as int;
      _loadCourse();
    }
  }

  Future<void> _loadCourse() async {
    try {
      final courseData = await CourseServices.getSelectedCourse(_courseId);
      if (mounted) {
        setState(() {
          _course = courseData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load course details';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null || _course == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error ?? 'Course not found'),
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
            _buildHeader(context, height, width),
            _buildCourseDetails(width),
            const Divider(),
            _buildInformationSection(width, height),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double height, double width) {
    final coverImage = _course!['cover_image'] as String?;
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

  Widget _buildCourseDetails(double width) {
    final location = _course!['location'] as Map<String, dynamic>?;
    final city = location?['city'] ?? '';
    final country = location?['country'] ?? '';

    return Padding(
      padding: EdgeInsets.all(width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _course!['name'] ?? '',
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

  Widget _buildInformationSection(double width, double height) {
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
                value: _course!['rating']?.toString() ?? '0',
                label: '${_course!['reviews_count']?.toString() ?? '0'} reviews',
                width: width,
              ),
              _buildDivider(height),
              _buildInfoItem(
                icon: Icons.favorite,
                value: _course!['likes_count']?.toString() ?? '0',
                label: 'Likes',
                width: width,
                iconColor: Colors.red,
              ),
              _buildDivider(height),
              _buildInfoItem(
                icon: Icons.golf_course,
                value: _course!['holes']?.toString() ?? '18',
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