import 'package:flutter/material.dart';
import 'constants.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: TopBar(
        title: 'L O G I N',
        backgroundColor: Colors.transparent,
        showBackButton: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.10,
              left: width * 0.05,
              right: width * 0.05,
            ),
            child: Container(
              height: height * 0.4,
              width: width * 0.9,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
              ),
            ),
          ),

          // Register button
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.05,
              right: width * 0.05,
              top: height * 0.02,
            ),
            child: SizedBox(
              height: height * 0.058,
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.black,
                  side: BorderSide(color: Colors.white, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Already have an account
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.04,
              left: width * 0.05,
              right: width * 0.05,
            ),
            child: Text(
              "Don't have an account? Register",
              style: TextStyle(
                color: Colors.black,
                fontSize: height * 0.02,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
