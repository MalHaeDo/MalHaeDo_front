import 'package:flutter/material.dart';

class ReplyAnimationScreen extends StatefulWidget {
  @override
  _ReplyAnimationScreenState createState() => _ReplyAnimationScreenState();
}

class _ReplyAnimationScreenState extends State<ReplyAnimationScreen>
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
      end: const Offset(2, -3),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward().then((_) {
      Navigator.pushNamed(context, '/replyDetail');
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
              'assets/images/Throw_Reply.gif', // GIF 파일
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SlideTransition(
              position: _animation,
              child: Image.asset(
                'assets/images/Throw_Reply.gif', // GIF 파일
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
