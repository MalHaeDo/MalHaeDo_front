import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:malhaeboredo/data/repositories/user_repository.dart';

class ReplyDetailScreen extends StatefulWidget {
  final String letterId;
  ReplyDetailScreen({required this.letterId});

  @override
  _ReplyDetailScreenState createState() => _ReplyDetailScreenState();
}

class _ReplyDetailScreenState extends State<ReplyDetailScreen> {
  late String _replyMessage;
  bool _isFirstMessage = true;
  String? videoUrl;
  String? letterImage;
  String? songTitle;
  String? profileImage;
  String? singer;
  String? senderName = '';
  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _loadReplyData(widget.letterId);
    _loadRecommendedSong(widget.letterId);
  }

  Future<void> _loadReplyData(String letterId) async {
    try {
      final replyData = await getRepliesByLetterId(letterId);
      setState(() {
        _replyMessage = replyData['content'];
        senderName = replyData['sender'];
        letterImage = _getLetterImage(senderName!);
        profileImage = _getProfileImage(senderName!);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _loadRecommendedSong(String letterId) async {
    try {
      final songData = await recommendLetter(letterId);
      setState(() {
        songTitle = songData['title'];
        singer = songData['singer'];
        videoUrl = songData['url'];
      });
    } catch (e) {
      // 오류 처리
    }
  }

  String _getLetterImage(String sender) {
    switch (sender) {
      case 'BAEBDURI':
        return 'assets/images/PaperPink.png';
      case 'DARAMI':
        return 'assets/images/PaperBlue.png';
      case 'PENGLE':
        return 'assets/images/paper.png';
      default:
        return 'assets/images/paper1.png';  
    }
  }

  String _getProfileImage(String sender) {
    switch (sender) {
      case 'BAEBDURI':
        return 'assets/images/Profile_bird.png';
      case 'DARAMI':
        return 'assets/images/Profile_daram.png';
      case 'PENGLE':
        return 'assets/images/Profile_pen.png';
      default:
        return 'assets/images/Profile_gom.png';  
    }
  }

  Future<Map<String, dynamic>> recommendLetter(String letterId) async {
  try {
    // API 호출
    final response = await _userRepository.recommendLetter(letterId);

    // 응답이 성공적인지 확인
    if (response['isSuccess'] == true) {
      return {
        'isSuccess': true,
        'title': response['result']['title'],
        'singer': response['result']['singer'],
        'songId': response['result']['songId'],
        'reason': response['result']['reason'],
        'url': response['result']['url'],
      };
    } else {
      throw Exception("추천 실패: ${response['message']}");
    }
  } catch (e) {
    throw Exception("추천 실패: $e");
  }
}

  Future<Map<String, dynamic>> getRepliesByLetterId(String letterId) async {
    try {
      final response = await _userRepository.getRepliesByLetterId(letterId);  // API 호출

      if (response['isSuccess'] == true) {
        return {
          'isSuccess': true,
          'message': response['message'],
          'replyId': response['result']['replyId'],
          'sender': response['result']['sender'],
          'content': response['result']['content'],
        };
      } else {
        throw Exception("답장 가져오기 실패: ${response['message']}");
      }
    } catch (e) {
      throw Exception("답장 가져오기 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.lightBlue.shade100],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 상단 헤더
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'From_말해도',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // 메시지 탭 선택
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                  _messageTab("$senderName 편지", true),
                  SizedBox(width: 10),
                  _messageTab("곰둥이장님 편지", false),
                  ],
                ),
              ),

              // 편지지 컨테이너
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(letterImage ?? 'assets/images/paper.png'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _messageHeader(),
                        _messageContent(),
                        _bottomButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 메시지 탭 선택 위젯
  Widget _messageTab(String text, bool isFirst) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isFirstMessage = isFirst;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: (_isFirstMessage == isFirst)
                ? (isFirst ? Color(0xFFFFD54F) : Colors.brown)
                : Colors.grey,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: (_isFirstMessage == isFirst)
                ? (isFirst ? Colors.black : Colors.white) :
                Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 편지 헤더
  Widget _messageHeader() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 20,
          child: Image.asset(
            profileImage ?? 'assets/images/paper.png', // Use Image.asset here
            width: 30,
            height: 30,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(width: 10),
        Text(
          'To. 웅이에게',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  );
}

  // 메시지 내용
  Widget _messageContent() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                _isFirstMessage ? _replyMessage : _replyMessage,
                style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
              ),
              SizedBox(height: 20),
              if (!_isFirstMessage)
                videoUrl == null
                    ? CircularProgressIndicator()
                    : YoutubePlayerScreen(videoUrl: videoUrl!),
            ],
          ),
        ),
      ),
    );
  }

  // 하단 버튼
  Widget _bottomButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _bottomButton('버리기', Colors.white, '/bottleLeft'),
          SizedBox(width: 16),
          _bottomButton('보관하기', _isFirstMessage ? Color(0xFFFFD54F) : Colors.brown, '/home', textColor: Colors.white),
        ],
      ),
    );
  }

  // 하단 버튼 생성
Widget _bottomButton(String text, Color color, String route, {Color textColor = Colors.black87}) {
  return Expanded(
    child: ElevatedButton(
      onPressed: () async {
        if (text == '버리기') {
          // 답장 삭제
          await _deleteReply(widget.letterId);
          setState(() {
            _replyMessage = ''; // 삭제 후 메시지 비우기
            senderName = ''; // 발신자 초기화
            letterImage = null; // 편지지 이미지 초기화
          });
        } else {
          // 보관하기 버튼일 경우
          Navigator.pushNamed(context, '/home');
        }
      },
      child: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    ),
  );
}

// 답장 삭제 함수
Future<void> _deleteReply(String letterId) async {
  try {
    // 실제 삭제 로직 호출
    await _userRepository.deleteReply(letterId);
  } catch (e) {
    print("답장 삭제 실패: $e");
    // 여기서 추가적인 오류 처리도 가능
  }
}
}

// 유튜브 플레이어 위젯
class YoutubePlayerScreen extends StatelessWidget {
  final String videoUrl;

  YoutubePlayerScreen({required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
        flags: YoutubePlayerFlags(autoPlay: false, mute: false),
      ),
      showVideoProgressIndicator: true,
    );
  }
}

