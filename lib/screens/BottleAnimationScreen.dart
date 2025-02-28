import 'package:flutter/material.dart';

class BottleAnimationScreen extends StatefulWidget {
  @override
  _BottleAnimationScreenState createState() => _BottleAnimationScreenState();
}

class _BottleAnimationScreenState extends State<BottleAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(2, -3), // 오른쪽 위로 날아가는 방향
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // 애니메이션 시작
    _controller.forward().then((_) {
      // 애니메이션 완료 후 자동으로 이전 화면으로 돌아가기
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/Throw_bottle.gif', // GIF 파일
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SlideTransition(
              position: _animation,
              child: Image.asset(
                'assets/images/Throw_bottle.gif', // GIF 파일
                width: 100,
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xDDDCC8B8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.wine_bar,
                      size: 50,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
