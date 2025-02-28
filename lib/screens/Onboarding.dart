import 'package:flutter/material.dart';

class FixedBackgroundProgressView extends StatefulWidget {
  @override
  _FixedBackgroundProgressViewState createState() => _FixedBackgroundProgressViewState();
}

class _FixedBackgroundProgressViewState extends State<FixedBackgroundProgressView> {
  final int _totalPages = 5;
  int _currentPage = 0;
  double _progress = 0.0;

  // 각 페이지에 표시될 대화 내용
  final List<Map<String, String>> _promptData = [
    {
      'title': '곰둥 이장님',
      'content': '안녕 오시게, 난 평안해를 주름잡는 말해도의 이장, 곰둥이라네.\n자네의 이름은 어떻게 되는가 뚜벅?',
      'button': '라고 해!'
    },
    {
      'title': '곰둥 이장님',
      'content': '웅..멋진 이름이로군 이 곳은 온전히 자네만 있는 섬, __도라네 뚜벅~',
      'button': '라고 해!'
    },
    {
      'title': '곰둥 이장님',
      'content': '',
      'button': '답문을 바라지 않으면?'
    },
    {
      'title': '곰둥 이장님',
      'content': '',
      'button': '답문을 바라지 않으면?'
    },
    {
      'title': '곰둥 이장님',
      'content': '',
      'button': '도움이 된다면 언제든지!'
    },
    {
      'title': '곰둥 이장님',
      'content': '',
      'button': '좋아 그럼 또 보자!'
    },
  ];

  void _goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() {
        _currentPage++;
        _progress = _currentPage / (_totalPages - 1);
      });
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _progress = _currentPage / (_totalPages - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
            // 고정된 배경 이미지
            Container(
            decoration: BoxDecoration(
              color: Color(0xFFAFE3F2), // 이미지 대신 하늘색 배경 (필요에 따라 AssetImage로 변경)
              image: DecorationImage(
              image: AssetImage('assets/images/Onboarding_image_${_currentPage + 1}.png'),
              fit: BoxFit.cover,
              ),
            ),
            ),
          
          // 뒤로가기 버튼
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: _goToPreviousPage,
            ),
          ),
          
          // 진행 상태 바
          Positioned(
            top: 50,
            left: 60,
            right: 16,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          
            // 현재 페이지 내용
            Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              SizedBox(height: 100),
              Image.asset(
                'assets/images/comment.png',
                width: 180,
                height: 180,
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                color: Color(0xFFF5ECD7),
                borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                children: [
                  Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xBF8D5A34),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _promptData[_currentPage]['title']!,
                    style: TextStyle(color: Colors.white),
                  ),
                  ),
                  SizedBox(height: 15),
                  if (_currentPage == 0) ...[
                  TextField(
                    onChanged: (value) {
                    setState(() {
                      _promptData[_currentPage]['content'] = '안녕 오시게, 난 평안해를 주름잡는 말해도의 이장, 곰둥이라네.\n자네의 이름은 어떻게 되는가 뚜벅?';
                    });
                    },
                    decoration: InputDecoration(
                    hintText: '내 이름은 (최대 5글자)',
                    ),
                  ),
                  ] else if (_currentPage == 1) ...[
                  TextField(
                    onChanged: (value) {
                    setState(() {
                      _promptData[_currentPage]['content'] = '웅..멋진 이름이로군 이 곳은 온전히 자네만 있는 섬, $value 도라네 뚜벅~';
                    });
                    },
                    decoration: InputDecoration(
                    hintText: '(최대 5글자)',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                    setState(() {
                      Future.delayed(Duration(seconds: 3), () {
                      setState(() {
                        _promptData[_currentPage]['content'] = '섬 이름이 설정되었습니다!';
                      });
                      });
                    });
                    },
                    child: Text('확인'),
                  ),
                  ] else ...[
                  Text(
                    _promptData[_currentPage]['content']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                  ],
                  SizedBox(height: 15),
                  Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  alignment: Alignment.center,
                  child: Text(_promptData[_currentPage]['button']!),
                  ),
                ],
                ),
              ),
              ],
            ),
            ),
          
          // 다음 버튼
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: ElevatedButton(
              onPressed: _goToNextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xBF8D5A34),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                '라고 해!',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}