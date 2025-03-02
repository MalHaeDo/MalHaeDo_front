import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:flutter/foundation.dart'; 
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
    return FlutterWebFrame(
      maximumSize: const Size(500.0, 900.0), // 최대 크기 설정
      enabled: kIsWeb, // 웹에서만 적용
      backgroundColor: Colors.grey[200], // 웹 배경색 설정
      builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: "/",
          routes: {
            '/': (context) => GuestScreen(),
            '/home': (context) => HomeScreen(),
            '/write': (context) => WriteScreen(),
            '/animation': (context) => BottleAnimationScreen(),
            '/reply': (context) => ReplyScreen(),
            '/replyDetail': (context) => ReplyDetailScreen(),
            '/replyAnimation': (context) => ReplyAnimationScreen(),
            '/bottleLeft': (context) => BottleLeftScreen(),
          },
        );
      },
    );
  }
}