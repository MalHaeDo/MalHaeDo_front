import 'package:flutter/material.dart';

class ReplyScreen extends StatefulWidget {
  @override
  _ReplyScreenState createState() => _ReplyScreenState();
}

class _ReplyScreenState extends State<ReplyScreen> {
  bool _showReplyModal = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Home_image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // 상단 상태 표시줄
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  Row(
                  children: [
                    Image.asset(
                    'assets/images/bottle.png',
                    width: 20,
                    height: 20,
                    ),
                    SizedBox(width: 4),
                    Text("2개", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
          
          // 하단 병 버튼
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.brown.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/bottle.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // 노란색 알림 (구름 위)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: MediaQuery.of(context).size.width * 0.5 - 15,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showReplyModal = true;
                });
              },
              child: Container(
                width: 30,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // 답장 모달
          if (_showReplyModal)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
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
                        'assets/images/full_bottle.png',
                        width: 60,
                        height: 60,
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/replyAnimation');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xB0815E),
                          iconColor: Color(0xBFA0622E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        ),
                        child: Text(
                          '답장 확인하기',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
