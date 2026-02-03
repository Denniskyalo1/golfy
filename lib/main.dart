import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:golfy/providers/courses_provider.dart';
import 'package:golfy/providers/selectedCourse_provider.dart';
import 'providers/auth_check_provider.dart';
import 'package:golfy/providers/homepage_provider.dart';
import 'package:golfy/providers/login_provider.dart';
import 'package:golfy/providers/profile_provider.dart';
import 'package:golfy/providers/register_provider.dart';
import 'package:provider/provider.dart';
import 'package:golfy/bag_clubs.dart';
import 'package:golfy/landingPage.dart';
import 'package:golfy/my_bag.dart';
import 'homepage.dart';
import 'register.dart';
import 'login.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthCheckProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => HomePageProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => CoursesProvider()),
        ChangeNotifierProvider(create: (_) => SelectedCourseProvider()),







      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Golfy',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const AuthCheck(),
        routes: {
          '/homePage': (context) => const Homepage(),
          '/register': (context) => Register(),
          '/login': (context) => Login(),
          '/landing': (context) => const LandingPage(),
          '/profile': (context) => const Profile(),
          '/myBag': (context) => const MyBag(),
          '/bagClubs': (context) => const BagClubs(),
          '/courses': (context) => const GolfCourses(),
          '/selectedCourse': (context) => const SelectedCourse(),
        },
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthCheckProvider>().checkLoginStatus(context);
    return const Scaffold(
      body: ColoredBox(
        color: Colors.white,
      ),
    );
  }
}
