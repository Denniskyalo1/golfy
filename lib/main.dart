import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:golfy/bag_clubs.dart';
import 'package:golfy/landingPage.dart';
import 'package:golfy/my_bag.dart';
import 'homepage.dart';
import 'register.dart';
import 'login.dart';
import 'user_prefs.dart';
import 'profile.dart';
import 'golfCourses.dart';
import 'selectedCourse.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Golfy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AuthCheck(),
      routes: {
        '/homePage': (context) => const Homepage(),
        '/register': (context) =>  Register(),
        '/login': (context) => Login(),
        '/landing': (context) => const LandingPage(),
        '/profile': (context) => const Profile(),
        '/myBag': (context) => const MyBag(),
        '/bagClubs': (context) => const BagClubs(),
        '/courses': (context) => const GolfCourses(),
        '/selectedCourse': (context) => const SelectedCourse(),
      },
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {

    final results = await Future.wait([
      UserPrefs.getUserName(),
      UserPrefs.getUserEmail(),
    ]);

    final userName = results[0];
    final userEmail = results[1];

    await Future.delayed(const Duration(milliseconds: 300));

    FlutterNativeSplash.remove();

    if (mounted) {
      final route = (userName != null && userEmail != null)
          ? '/homePage'
          : '/landing';

      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ColoredBox(
        color: Colors.white,
      ),
    );
  }
}