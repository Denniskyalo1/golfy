import 'package:flutter/material.dart';
import 'package:golfy/constants.dart';

class BagClubs extends StatefulWidget {
  const BagClubs({super.key});

  @override
  State<BagClubs> createState() => _BagClubsState();
}

class _BagClubsState extends State<BagClubs> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
    appBar: TopBar(
      title: 'D R I V E R S',
      backgroundColor: Colors.transparent,
      showBackButton: true,
    ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
