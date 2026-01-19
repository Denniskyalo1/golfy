import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:golfy/constants.dart';
import 'user_prefs.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text(
            'Are you sure you want to Log out? Click yes to proceed.',
          ),
          actions: [
            MaterialButton(onPressed: () {}, child: Text('No')),
            MaterialButton(
              onPressed: () async {
                Navigator.pop(context);
                await UserPrefs.clearUser();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              },
              child: Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  void loadUserDetails() async {
    final name = await UserPrefs.getUserName();
    final email = await UserPrefs.getUserEmail();
    setState(() {
      userName = name ?? '';
      userEmail = email ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: TopBar(
        showBackButton: true,
        backgroundColor: Colors.white,
        title: 'P R O F I L E',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // USER DETAILS
            Container(
              width: width,
              height: height * 0.15,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: height * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: height * 0.11,
                            width: height * 0.11,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(50),
                              image: const DecorationImage(
                                image: AssetImage('images/profilepic.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: width * 0.4,
                                child: Text(
                                  userName,
                                  style: TextStyle(
                                    fontSize: height * 0.02,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.4,
                                child: Text(
                                  userEmail,
                                  style: TextStyle(
                                    fontSize: height * 0.018,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.015),
                              Text(
                                'Handicap',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: height * 0.02,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: height * 0.02,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: height * 0.03),

            // PLAYER PERFORMANCE
            sectionTitle('Player Performance', height),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  ProfileOptionTile(
                    leading: Icon(Icons.h_plus_mobiledata, size: height * 0.03),
                    title: 'Handicap Details',
                    onTap: () {},
                  ),
                  ProfileOptionTile(
                    leading: Icon(Icons.access_time, size: height * 0.03),
                    title: 'Recent Rounds',
                    onTap: () {},
                  ),
                  ProfileOptionTile(
                    leading: Icon(Icons.score_sharp, size: height * 0.03),
                    title: 'Scoring History',
                    onTap: () {},
                  ),
                  ProfileOptionTile(
                    leading: Icon(Icons.golf_course, size: height * 0.03),
                    title: 'Recent Courses',
                    showDivider: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.03),

            // GAME SETTINGS
            sectionTitle('Game Settings', height),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  ProfileOptionTile(
                    leading: Icon(Icons.grid_on_rounded, size: height * 0.03),
                    title: 'Scoring Display',
                    onTap: () {},
                  ),
                  ProfileOptionTile(
                    leading: Icon(Icons.map_sharp, size: height * 0.03),
                    title: 'Maps Settings',
                    onTap: () {},
                  ),
                  ProfileOptionTile(
                    leading: SvgPicture.asset(
                      'images/clubs.svg',
                      width: height * 0.03,
                      height: height * 0.03,
                    ),
                    title: 'Clubs Settings',
                    showDivider: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.03),

            // ACHIEVEMENTS & BADGES
            sectionTitle('Achievements & Badges', height),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  ProfileOptionTile(
                    leading: Icon(Icons.emoji_events, size: height * 0.03),
                    title: 'Achievements',
                    onTap: () {},
                  ),
                  ProfileOptionTile(
                    leading: Icon(Icons.workspace_premium, size: height * 0.03),
                    title: 'Badges',
                    showDivider: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.05),

            //App & Support
            sectionTitle('App & Support', height),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  ProfileOptionTile(
                    leading: Icon(Icons.contact_support, size: height * 0.03),
                    title: 'Help & Support',
                    onTap: () {},
                  ),
                  ProfileOptionTile(
                    leading: Icon(Icons.feedback, size: height * 0.03),
                    title: 'Feedback',
                    onTap: () {},
                  ),
                  ProfileOptionTile(
                    leading: Icon(Icons.info_rounded, size: height * 0.03),
                    title: 'About App',
                    onTap: () {},
                  ),
                  ProfileOptionTile(
                    leading: Icon(
                      Icons.logout,
                      size: height * 0.03,
                      color: Colors.red,
                    ),
                    title: 'Logout',
                    onTap: _showDialog,
                    showDivider: false,
                    textColor: Colors.red,
                    arrowColor: Colors.red,
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.05),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title, double height) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        bottom: height * 0.01,
        top: height * 0.01,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black54,
          fontSize: height * 0.02,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// REUSABLE TILE
class ProfileOptionTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final VoidCallback? onTap;
  final bool showDivider;
  final Color textColor;
  final Color? arrowColor;

  const ProfileOptionTile({
    super.key,
    required this.leading,
    required this.title,
    this.onTap,
    this.showDivider = true,
    this.textColor = Colors.black,
    this.arrowColor,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(0),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: height * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      leading,
                      SizedBox(width: 12),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: height * 0.02,
                          fontWeight: FontWeight.w400,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: height * 0.02,
                    color: arrowColor ?? Colors.blueAccent,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(height: 1, color: Colors.black26),
          ),
      ],
    );
  }
}
