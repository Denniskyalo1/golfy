import 'dart:ui';

import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SizedBox.expand(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image(
                  image: AssetImage('images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              /*Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin:Alignment.topCenter ,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withAlpha(10),
                      Colors.transparent,
                    ],
                  )
                ),
              ),*/
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: height * 0.3,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.0,-2.5) ,
                        end: Alignment.bottomCenter,
                        colors:[
                          Colors.transparent,
                          Colors.white.withOpacity(0.16)
                        ]
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: height * 0.26,
                  left: width * 0.05,
                  right: 0,
                  child:Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: Text(
                        'Your number one',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
              ),
              Positioned(
                  bottom: height * 0.2,
                  left: width * 0.05,
                  right: 0,
                  child:Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: Text(
                      'GOLF COMPANION',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
              ),
              Positioned(
                  bottom: height * 0.14,
                  left: width * 0.05,
                  right: width* 0.05,
                  child:Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: Text(
                      'Track Games, Improve Swing and Connect With Golfers Worldwide - All in One App ',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
              ),
              Positioned(
                bottom: height * 0.07,
                  left: width * 0.05,
                  right: width * 0.05,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: Colors.white.withAlpha(0),
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(200, height * 0.06),
                              side: BorderSide(color: Colors.white, width: 1.5),
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/homePage');},
                            child: Text(
                              'Get Started',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ),
                  )
              )


            ]

          ),
        ),

    );
  }
}
