import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:golfy/landingPage.dart';
import 'homepage.dart';
import 'register.dart';
import 'login.dart';
import 'user_prefs.dart';
import 'profile.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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
      ),
      home: AuthCheck(),
      routes: {
        '/homePage': (context) => const Homepage(),
        '/register': (context) => Register(),
        '/login': (context) => Login(),
        '/landing': (context) => const LandingPage(),
        '/profile': (context) => const Profile(),
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
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    final userName = await UserPrefs.getUserName();
    final userEmail = await UserPrefs.getUserEmail();

    await Future.delayed(Duration(milliseconds: 500));

    FlutterNativeSplash.remove();

    if (mounted) {
      if (userName != null && userEmail != null) {
        Navigator.pushReplacementNamed(context, '/homePage');
      } else {
        Navigator.pushReplacementNamed(context, '/landing');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Match splash background
      ),
    );
  }
}