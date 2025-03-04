import 'package:flutter/material.dart';
import 'package:malhaeboredo/screens/Onboarding.dart';
import 'package:malhaeboredo/screens/HomeScreen.dart';
import 'package:malhaeboredo/screens/WriteScreen.dart';
import 'package:malhaeboredo/screens/BottleAnimationScreen.dart';
import 'package:malhaeboredo/screens/ReplyScreen.dart';
import 'package:malhaeboredo/screens/ReplyDetailScreen.dart';
import 'package:malhaeboredo/screens/ReplyAnimationScreen.dart';
import 'package:malhaeboredo/screens/BottleLeft.dart';
import 'package:malhaeboredo/screens/GuestScreen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //스플래쉬 화면 제거
      initialRoute: "/",
      routes: {
        //'/Onboarding': (context) => FixedBackgroundProgressView(),
        '/': (context) => GuestScreen(),
        '/home': (context) => HomeScreen(),
        '/write': (context) => WriteScreen(),
        '/animation' : (context) => BottleAnimationScreen(),
        '/reply' : (context) => ReplyScreen(),
        '/replyDetail' : (context) => ReplyDetailScreen(),
        '/replyAnimation' : (context) => ReplyAnimationScreen(),
        '/bottleLeft' : (context) => BottleLeftScreen(),
      },
    );
  }
}