import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:golfy/constants.dart';
import 'package:provider/provider.dart';
import 'providers/profile_provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text(
            'Are you sure you want to Log out? Click yes to proceed.',
          ),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            MaterialButton(
              onPressed: _handleLogout,
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLogout() async {
    Navigator.pop(context);
    await context.read<ProfileProvider>().logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: const TopBar(
        showBackButton: true,
        backgroundColor: Colors.white,
        title: 'P R O F I L E',
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          return profileProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // USER DETAILS
                _buildUserDetailsCard(context, height, width, profileProvider),

                SizedBox(height: height * 0.03),

                // PLAYER PERFORMANCE
                _buildSectionTitle('Player Performance', height),
                _buildPlayerPerformanceSection(height),

                SizedBox(height: height * 0.03),

                // GAME SETTINGS
                _buildSectionTitle('Game Settings', height),
                _buildGameSettingsSection(height),

                SizedBox(height: height * 0.03),

                // ACHIEVEMENTS & BADGES
                _buildSectionTitle('Achievements & Badges', height),
                _buildAchievementsSection(height),

                SizedBox(height: height * 0.05),

                // APP & SUPPORT
                _buildSectionTitle('App & Support', height),
                _buildAppSupportSection(height),

                SizedBox(height: height * 0.05),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserDetailsCard(BuildContext context, double height, double width, ProfileProvider profileProvider) {
    return Container(
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
                          profileProvider.userName,
                          style: TextStyle(
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.4,
                        child: Text(
                          profileProvider.userEmail,
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
    );
  }

  Widget _buildPlayerPerformanceSection(double height) {
    return Container(
      decoration: const BoxDecoration(
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
    );
  }

  Widget _buildGameSettingsSection(double height) {
    return Container(
      decoration: const BoxDecoration(
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
    );
  }

  Widget _buildAchievementsSection(double height) {
    return Container(
      decoration: const BoxDecoration(
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
    );
  }

  Widget _buildAppSupportSection(double height) {
    return Container(
      decoration: const BoxDecoration(
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
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: 'Logout',
            onTap: _showLogoutDialog,
            showDivider: false,
            textColor: Colors.red,
            arrowColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, double height) {
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
                      const SizedBox(width: 12),
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, color: Colors.black26),
          ),
      ],
    );
  }
}