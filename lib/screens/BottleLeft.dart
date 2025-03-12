import 'package:flutter/material.dart';

class BottleLeftScreen extends StatelessWidget {
  const BottleLeftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushNamed(context, '/home');
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Image.asset(
          'assets/images/Throw_away.gif', // GIF file
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}