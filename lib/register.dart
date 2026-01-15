
import 'dart:ui';

import 'package:flutter/material.dart';
import 'constants.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: TopBar(title:'R E G I S T E R',backgroundColor: Colors.transparent,showBackButton: true,),
      body: Column(
        children: [
          Padding(
            padding:  EdgeInsets.only(top: height * 0.10, left: width * 0.05, right: width * 0.05),
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
          Padding(
                padding: EdgeInsets.only(left: width * 0.05, right: width*0.05, top: height*0.02),
                child: SizedBox(
                  height: height * 0.058,
                  width: double.infinity,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white, width: 1.5),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        )
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');},
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
              ),

          Padding(
            padding:  EdgeInsets.only(top: height * 0.04, left: width * 0.05, right: width * 0.05),
            child: Text(
              'Already have an account? Login',
              style:TextStyle(
                color: Colors.black,
                fontSize: height * 0.02,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),

    );
  }
}
