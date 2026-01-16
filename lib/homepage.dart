import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'G O L F Y',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white
        ,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.person),
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
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

                  _drawerItem(Icons.home, 'Profile', () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/register');
                  }),
                  _drawerItem(Icons.golf_course, 'Golf Courses', () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/golfCourses');
                  }),
                  _drawerItem(Icons.sports_golf, 'My Games', () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/myGames');
                  }),
                  ListTile(
                    leading: SvgPicture.asset(
                      'images/clubs.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                    title: Text('My Clubs'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/myClubs');
                    },
                  ),
                  _drawerItem(Icons.group, 'Friends', () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/friends');
                  }),
                  _drawerItem(Icons.settings, 'Settings', () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/settings');
                  }),
                  _drawerItem(Icons.support_agent, 'Support', () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/support');
                  }),

                  Spacer(),

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
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image(
                image: AssetImage('images/wallpaper.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
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
                    child: Text(
                      'DENNIS KYALO',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: height * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                   SizedBox(height: height * 0.04,),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                    child: Container(
                      height: height * 0.35,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
