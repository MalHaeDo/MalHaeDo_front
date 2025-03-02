import 'package:flutter/material.dart'; // 홈 화면 import

class GuestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/home');
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/images/background_image.png", // 배경 PNG
              fit: BoxFit.cover,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "감정을 던져보세요",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  "말해도",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 200),
                Text(
                  "게스트로 입장하기",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
