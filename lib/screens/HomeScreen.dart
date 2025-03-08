import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:malhaeboredo/data/repositories/user_repository.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showMessage = false;
  int _sentCount = 0;
  int _repliedCount = 0;
  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
  super.initState();
  _checkSavedMessage();
}

void _checkSavedMessage() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    _showMessage = prefs.getString('saved_message') != null;
  });
}

void _fetchReplyStorage() async {
    try {
      final response = await _userRepository.getReplyStorage();  // UserRepository를 통해 API 호출
      setState(() {
        _sentCount = response['result']['sentCount'];
        _repliedCount = response['result']['repliedCount'];
      });
    } catch (e) {
      // 실패 시 처리
      print("Error fetching reply storage: $e");
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Home_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // 상단 바
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Row(
                      children: [
                      Image.asset(
                      'assets/images/full_bottle.png',
                      width: 20,
                      height: 20,
                      ),
                      SizedBox(width: 20),
                      Text(
                      '$_sentCount개',
                      style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      ),
                      ),
                      ],
                    ),
          //마이페이지 삭제
                  ],
                ),
              ),
            ),
            
            // 하단 메시지와 병 버튼
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
                      _showMessage ? '힘껏 날려보시게!' : '모든 감정을 담아보게, 괜찮네',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // 병 모양 버튼
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.pushNamed(context, '/write');
                      if (result == true) {
                        setState(() {
                          _showMessage = true;
                        });
                        Navigator.pushNamed(context, '/animation').then((_) {
                          // Handle any post-animation logic here
                        });
                      }
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
          ],
        ),
      ),
    );
  }
}
