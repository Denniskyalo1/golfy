import 'package:flutter/material.dart';
import 'package:golfy/constants.dart';

class BagClubs extends StatelessWidget {
  const BagClubs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: const TopBar(
        title: 'D R I V E R S',
        backgroundColor: Colors.transparent,
        showBackButton: true,
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}