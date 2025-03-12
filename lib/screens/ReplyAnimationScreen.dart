import 'package:flutter/material.dart';

class ReplyAnimationScreen extends StatelessWidget {
  const ReplyAnimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushNamed(context, '/reply');
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Image.asset(
          'assets/images/Throw_reply.gif', // GIF file
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
