import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 추가
import 'package:malhaeboredo/screens/OnboardingScreen.dart';
import 'package:malhaeboredo/screens/HomeScreen.dart';
import 'package:malhaeboredo/screens/WriteScreen.dart';
import 'package:malhaeboredo/screens/BottleAnimationScreen.dart';
import 'package:malhaeboredo/screens/ReplyScreen.dart';
import 'package:malhaeboredo/screens/ReplyDetailScreen.dart';
import 'package:malhaeboredo/screens/ReplyAnimationScreen.dart';
import 'package:malhaeboredo/screens/BottleLeft.dart';
import 'package:malhaeboredo/screens/LoginScreen.dart';
import 'package:malhaeboredo/screens/SplashScreen.dart';
import 'package:malhaeboredo/screens/MyPageScreen.dart';

void main() {
  runApp(
    ProviderScope(  // ProviderScope 추가
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Moneygraphy',
      ),
      initialRoute: "/",
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => SplashScreen());
          case '/login':
            return MaterialPageRoute(builder: (context) => LoginScreen());
          case '/Onboarding':
            return MaterialPageRoute(builder: (context) => OnboardingScreen());
          case '/home':
            return MaterialPageRoute(builder: (context) => HomeScreen());
          case '/write':
            return MaterialPageRoute(builder: (context) => WriteScreen());
          case '/animation':
            return MaterialPageRoute(builder: (context) => BottleAnimationScreen());
          case '/reply':
            return MaterialPageRoute(builder: (context) => ReplyScreen());
          case '/replyAnimation':
            return MaterialPageRoute(builder: (context) => ReplyAnimationScreen());
          case '/bottleLeft':
            return MaterialPageRoute(builder: (context) => BottleLeftScreen());
          case '/mypage':
            return MaterialPageRoute(builder: (context) => MyPageScreen());
          case '/replyDetail':
            final int letterId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) => ReplyDetailScreen(letterId: letterId),
            );
          default:
            return null;
        }
      },
    );
  }
}
