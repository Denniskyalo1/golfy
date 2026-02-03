import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:golfy/constants.dart';
import 'providers/homepage_provider.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  void _navigateWithAuthCheck(
      BuildContext context,
      HomePageProvider provider,
      String routeName,
      ) {
    if (!provider.isLoggedIn) {
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

  Future<void> _handleLogout(
      BuildContext context,
      HomePageProvider provider,
      ) async {
    Navigator.pop(context);
    await provider.logout();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomePageProvider>();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const TopBar(
        showBackButton: false,
        backgroundColor: Colors.transparent,
        title: 'P A R F E C T',
      ),
      drawer: _buildDrawer(context, provider, height, width),
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
                        fontSize: height * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.05),
                    child: provider.isLoading
                        ? SizedBox(
                      height: height * 0.05,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                        : Text(
                      provider.userName.isEmpty
                          ? 'Guest'
                          : provider.userName,
                      style: TextStyle(
                        fontSize: height * 0.05,
                        fontWeight: FontWeight.bold,
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

  Widget _buildDrawer(
      BuildContext context,
      HomePageProvider provider,
      double height,
      double width,
      ) {
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
                        fontSize: height * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                _drawerItem(
                  Icons.home,
                  'Profile',
                      () => _navigateWithAuthCheck(context, provider, '/profile'),
                  height,
                ),
                _drawerItem(
                  Icons.golf_course,
                  'Golf Courses',
                      () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/courses');
                  },
                  height,
                ),
                _drawerItem(
                  Icons.sports_golf,
                  'My Games',
                      () => _navigateWithAuthCheck(context, provider, '/myGames'),
                  height,
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    'images/clubs.svg',
                    width: 24,
                    height: 24,
                    colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ),
                  title: const Text('My Bag'),
                  onTap: () =>
                      _navigateWithAuthCheck(context, provider, '/myBag'),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: height * 0.05),
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.red[500]),
                    title: Text(
                      'Log Out',
                      style: TextStyle(color: Colors.red[500]),
                    ),
                    onTap: () => _handleLogout(context, provider),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(
      IconData icon,
      String title,
      VoidCallback onTap,
      double height,
      ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: TextStyle(fontSize: height * 0.02)),
      onTap: onTap,
    );
  }
}
