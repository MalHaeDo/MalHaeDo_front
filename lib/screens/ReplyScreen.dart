import 'package:flutter/material.dart';
import 'package:malhaeboredo/data/repositories/user_repository.dart';

class ReplyScreen extends StatefulWidget {
  @override
  _ReplyScreenState createState() => _ReplyScreenState();
}

class _ReplyScreenState extends State<ReplyScreen> {
  String? _letterId;
  String? _senderName;
  int _repliedCount= 0;
  bool _isLoading = true;
  int _replyId = 0;
  bool _showReplyModal = false;

  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchLetterData();
  }

  Future<void> _fetchLetterData() async {
    try {
      final response = await _userRepository.getRepliesByLetterId(_replyId);
      if (response['isSuccess']) {
        setState(() {
          _senderName = response['result']['sender']; // sender 정보 저장
          _isLoading = false;
          _replyId = response['result']['replyId'];
          print(_senderName);
          print(_replyId);
        });
      }
    } catch (e) {
      print("API 호출 오류: $e");
      setState(() => _isLoading = false);
    }
  }

  void _fetchReplyStorage() async {
    try {
      final response = await _userRepository.getReplyStorage();
      setState(() {
        _repliedCount = response['result']['repliedCount'];
      });
    } catch (e) {
      print("Error fetching reply storage: $e");
    }
  }

  String getSenderIcon(String? sender) {
    switch (sender) {
      case "BAEBDURI":
        return 'assets/images/Alarm_Bap.png';
      case "DARAMI":
        return 'assets/images/Alarm_Da.png';
      case "PENGLE":
        return 'assets/images/Alarm_Pen.png';
      default:
        return 'assets/images/Bear.png'; 
    }
  }

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
                padding: EdgeInsets.only(left: 20, top: 20),
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
                          '$_repliedCount개',
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
                      child: Center(
                        child: Image.asset(
                          'assets/images/bottle.png', // 병 아이콘 이미지 (없으면 아이콘으로 대체)
                          width: 60,
                          height: 60,
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
          if (!_isLoading && _letterId != null)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: MediaQuery.of(context).size.width * 0.5 - 15,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/replyDetail',
                    arguments: _letterId, // letterId 전달
                  );
                },
                child: Image.asset(
                  getSenderIcon(_senderName), // sender에 맞는 느낌표 PNG 사용
                  width: 30,
                  height: 30,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
