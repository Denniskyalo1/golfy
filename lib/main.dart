import 'package:flutter/material.dart';
import 'package:golfy/landingPage.dart';
import 'homepage.dart';
import 'register.dart';
import 'login.dart';


void main() {
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
      initialRoute: '/',
      routes:{
        '/': (context) => const LandingPage(),
        '/homePage' :(context) => const Homepage(),
        '/register' :(context) => const Register(),
        '/login' : (context) => const Login()

      },
    );
  }
}
