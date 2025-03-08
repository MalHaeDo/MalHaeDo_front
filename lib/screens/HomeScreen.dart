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
    _fetchReplyStorage(); // API 호출 추가
  }

  // 저장된 메시지를 확인
  void _checkSavedMessage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showMessage = prefs.getString('saved_message') != null;
    });
  }

  // 사용자 API 호출하여 데이터 받아오기
  void _fetchReplyStorage() async {
    try {
      final response = await _userRepository.getReplyStorage();
      setState(() {
        _sentCount = response['result']['sentCount'];
        _repliedCount = response['result']['repliedCount'];
      });
    } catch (e) {
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
                        SizedBox(width: 5),
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
                    SizedBox(width: 100),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.pushNamed(context, '/mypage');
                      },
                      child: Image.asset(
                        'assets/images/UserCircle.png', // 아이콘 이미지
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Column(
                children: [
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
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.pushNamed(context, '/write');
                      if (result == true) {
                        setState(() {
                          _showMessage = true;
                        });
                        Navigator.pushNamed(context, '/animation');
                      }
                    },
                    child: Container(
                      child: Center(
                        child: Image.asset(
                          'assets/images/bottle.png',
                          width: 60,
                          height: 60,
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
