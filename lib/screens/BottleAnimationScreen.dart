import 'package:flutter/material.dart';

class BottleAnimationScreen extends StatelessWidget {
  const BottleAnimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushNamed(context, '/replyAnimation');
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Image.asset(
          'assets/images/Throw_bottle.gif', // GIF file
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
