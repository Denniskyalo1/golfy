import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:golfy/constants.dart';
import 'user_prefs.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _userName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await UserPrefs.getUserName();
    if (mounted) {
      setState(() {
        _userName = name ?? '';
        _isLoading = false;
      });
    }
  }

  void _navigateWithAuthCheck(String routeName) {
    if (_userName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in first before proceeding.')),
      );
      Navigator.pop(context);
      Navigator.pushNamed(context, '/login');
      return;
    }
    Navigator.pop(context);
    Navigator.pushNamed(context, routeName);
  }

  Future<void> _handleLogout() async {
    Navigator.pop(context);
    await UserPrefs.clearUser();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const TopBar(
        showBackButton: false,
        backgroundColor: Colors.transparent,
        title: 'P A R F E C T',
      ),
      drawer: _buildDrawer(context, height, width),
      body: SizedBox.expand(
        child: Stack(
          children: [
            const Positioned.fill(
              child: Image(
                image: AssetImage('images/wallpaper.jpg'),
                fit: BoxFit.cover,
              ),
            ),

            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.05,
                      top: height * 0.02,
                    ),
                    child: Text(
                      'HELLO,',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: height * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: width * 0.05),
                    child: _isLoading
                        ? SizedBox(
                      height: height * 0.05,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      _userName.isEmpty ? 'Guest' : _userName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: height * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.04),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Container(
                      height: height * 0.35,
                      decoration: const BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, double height, double width) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            color: Colors.white.withOpacity(0.15),
            child: Column(
              children: [
                DrawerHeader(
                  child: Center(
                    child: Text(
                      'M E N U',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: height * 0.04,
                      ),
                    ),
                  ),
                ),

                _buildDrawerItem(
                  icon: Icons.home,
                  title: 'Profile',
                  onTap: () => _navigateWithAuthCheck('/profile'),
                  height: height,
                ),

                _buildDrawerItem(
                  icon: Icons.golf_course,
                  title: 'Golf Courses',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/courses');
                  },
                  height: height,
                ),

                _buildDrawerItem(
                  icon: Icons.sports_golf,
                  title: 'My Games',
                  onTap: () => _navigateWithAuthCheck('/myGames'),
                  height: height,
                ),

                ListTile(
                  leading: SvgPicture.asset(
                    'images/clubs.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                  title: const Text('My Bag'),
                  onTap: () => _navigateWithAuthCheck('/myBag'),
                ),

                _buildDrawerItem(
                  icon: Icons.group,
                  title: 'Friends',
                  onTap: () => _navigateWithAuthCheck('/friends'),
                  height: height,
                ),

                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/settings');
                  },
                  height: height,
                ),

                _buildDrawerItem(
                  icon: Icons.support_agent,
                  title: 'Support',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/support');
                  },
                  height: height,
                ),

                const Spacer(),

                Padding(
                  padding: EdgeInsets.only(bottom: height * 0.05),
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.red[500]),
                    title: Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.red[500],
                        fontSize: height * 0.02,
                      ),
                    ),
                    onTap: _handleLogout,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required double height,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: height * 0.02,
        ),
      ),
      onTap: onTap,
    );
  }
}