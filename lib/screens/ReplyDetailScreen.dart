import 'package:flutter/material.dart';

class ReplyDetailScreen extends StatefulWidget {
  @override
  _ReplyDetailScreenState createState() => _ReplyDetailScreenState();
}

class _ReplyDetailScreenState extends State<ReplyDetailScreen> {
  final String _replyMessage1 = "에구, 많이 속상했겠다 헤헷, 나도 비슷한 기분을 느낀 적이 있어. 우리 집에서도 형만 예뻐하는 것 같아서 한동안 마음이 꽁꽁 얼어붙었거든, '나는 왜 이렇게 투명인간 같지? 싶었어. 아무리 노력해도 인정받지 못하는 것 같아서 너무 서러웠지 헤헷.";
  final String _replyMessage2 = "에구, 많이 속상했겠다 헤헷, 나도 비슷한 기분을 느낀 적이 있어. 우리 집에서도 형만 예뻐하는 것 같아서 한동안 마음이 꽁꽁 얼어붙었거든, '나는 왜 이렇게 투명인간 같지? 싶었어. 아무리 노력해도 인정받지 못하는 것 같아서 너무 서러웠지 헤헷.";
  bool _isFirstMessage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Writing_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 상단 헤더
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'From_말해도',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // 편지지 컨테이너
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(_isFirstMessage ? 'assets/images/paper.png' : 'assets/images/paper1.png'),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                    children: [
                      // 상단 메시지
                      Container(
                      margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xBFA0622E),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        Text(
                          _isFirstMessage ? '펭글이 편지' : '곰둥이장님 편지',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.swap_horiz, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _isFirstMessage = !_isFirstMessage;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          _isFirstMessage ? _replyMessage1 : _replyMessage2,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      
                      Spacer(),
                    ],
                  ),
                ),
              ),
              
              // 하단 버튼
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                      '버리기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // 글자색상 변경
                      ),
                      ),
                      style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xBFA0622E),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                      '보관하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // 글자색상 변경
                      ),
                      ),
                      style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xBFA0622E),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
