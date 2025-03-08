import 'package:flutter/material.dart';
import 'package:malhaeboredo/screens/Onboarding.dart';
import 'package:malhaeboredo/screens/HomeScreen.dart';
import 'package:malhaeboredo/screens/WriteScreen.dart';
import 'package:malhaeboredo/screens/BottleAnimationScreen.dart';
import 'package:malhaeboredo/screens/ReplyScreen.dart';
import 'package:malhaeboredo/screens/ReplyDetailScreen.dart';
import 'package:malhaeboredo/screens/ReplyAnimationScreen.dart';
import 'package:malhaeboredo/screens/BottleLeft.dart';
import 'package:malhaeboredo/screens/LoginScreen.dart';
import 'package:malhaeboredo/screens/SplashScreen.dart';
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
      onGenerateRoute: (settings) {
        if (settings.name == '/replyDetail') {
          final String letterId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ReplyDetailScreen(letterId: letterId),
          );
        }
        return null;
      },
      routes: {
        '/': (context) => SplashScreen(),
        '/Onboarding': (context) => FixedBackgroundProgressView(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/write': (context) => WriteScreen(),
        '/animation' : (context) => BottleAnimationScreen(),
        '/reply' : (context) => ReplyScreen(),
        '/replyAnimation' : (context) => ReplyAnimationScreen(),
        '/bottleLeft' : (context) => BottleLeftScreen(),
      },
    );
  }
}