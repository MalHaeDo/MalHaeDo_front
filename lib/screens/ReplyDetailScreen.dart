import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ReplyDetailScreen extends StatefulWidget {
  @override
  _ReplyDetailScreenState createState() => _ReplyDetailScreenState();
}

class _ReplyDetailScreenState extends State<ReplyDetailScreen> {
  final String _replyMessage =
      "\"에구, 많이 속상했겠다 헤헷, 나도 비슷한 기분을 느낀 적이 있어. 우리 집에서도 형만 예뻐하는 것 같아서 한동안 마음이 꽁꽁 얼어붙었거든. '나는 왜 이렇게 투명인간 같지?' 싶었어, 아무리 노력해도 인정받지 못하는 것 같아서 너무 서러웠지 헤헷.";
  final String _replyMessage1 =
      "\"음...바다처럼 깊겠구먼...노력해도 부족한 것 같을 때, 정말 답답하고 지치는 법이지... 하지만 말이야, 너의 노력도 언젠가 흐름을 타게 될 것이야, 뚜벅. 그래서 나는 이하이의 '한숨'이 노래를 추천하네. 이 노래는 말이지, 우리가 스스로 이겨낼";

  bool _isFirstMessage = true;
  String? videoUrl;

  @override
  void initState() {
    super.initState();
    loadDummyVideoUrl();
  }

  void loadDummyVideoUrl() async {
    setState(() {
      videoUrl = 'https://www.youtube.com/watch?v=5iSlfF8TQ9k';
    });
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
                  _messageTab("펭글이 편지", true),
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
                      image: AssetImage(_isFirstMessage
                          ? 'assets/images/paper.png'
                          : 'assets/images/paper1.png'),
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
            color: (_isFirstMessage == isFirst) ? Color(0xFFFFD54F) : Colors.grey,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: (_isFirstMessage == isFirst) ? Colors.black : Colors.white,
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
            child: SvgPicture.asset(
              _isFirstMessage
                  ? 'assets/images/penguin.svg'
                  : 'assets/images/bear.svg',
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
              Text(
                '안녕 웅아!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xBFA0622E),
                ),
              ),
              SizedBox(height: 10),
              Text(
                _isFirstMessage ? _replyMessage : _replyMessage1,
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
          _bottomButton('보관하기', _isFirstMessage ? Color(0xFFFFD54F) : Colors.brown, '/home'),
        ],
      ),
    );
  }

  // 하단 버튼 생성
  Widget _bottomButton(String text, Color color, String route) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, route),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
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
