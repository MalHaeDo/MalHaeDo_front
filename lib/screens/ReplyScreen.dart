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
              bottom: 80,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // 메시지 말풍선
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xBFA0622E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '답장이 도착했네!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // 병 모양 버튼
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/write');
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xDDDCC8B8),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/bottle.png', // 병 아이콘 이미지 (없으면 아이콘으로 대체)
                          width: 30,
                          height: 30,
                          // 이미지가 없는 경우 아래 child 대신 사용
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.wine_bar,
                              color: Colors.white,
                              size: 30,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
   
          
          // 노란색 알림 (구름 위)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: MediaQuery.of(context).size.width * 0.5 - 15,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  Navigator.of(context).pushNamed('/replyDetail');
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
        ],
      ),
    );
  }
}
