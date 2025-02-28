import 'package:flutter/material.dart';

class ReplyScreen extends StatefulWidget {
  @override
  _ReplyScreenState createState() => _ReplyScreenState();
}

class _ReplyScreenState extends State<ReplyScreen> {
  bool _showReply = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('답장이 도착했어요'),
        backgroundColor: Color(0xBFA0622E),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Home_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: _showReply
              ? Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                      '누군가가 당신의 메시지에 답장했어요',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xBFA0622E),
                      ),
                      ),
                      SizedBox(height: 20),
                      Text(
                      '당신의 마음이 바다를 건너 누군가에게 닿았습니다. 그들이 보낸 따뜻한 응원의 메시지를 확인해보세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 30),
                      Image.asset(
                      'assets/images/bottle.png',
                      width: 60,
                      height: 60,
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/replyAnimation');
                      },
                      child: Text('답장 확인하기'),
                      ),
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _showReply = true;
                    });
                  },
                  child: Icon(
                    Icons.notification_important,
                    size: 100,
                    color: Colors.red,
                  ),
                ),
        ),
      ),
    );
  }
}