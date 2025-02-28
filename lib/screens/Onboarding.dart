import 'package:flutter/material.dart';

class FixedBackgroundProgressView extends StatefulWidget {
  @override
  _FixedBackgroundProgressViewState createState() => _FixedBackgroundProgressViewState();
}

class _FixedBackgroundProgressViewState extends State<FixedBackgroundProgressView> {
  final int _totalPages = 6;
  int _currentPage = 0;
  double _progress = 0.0;

  final List<Map<String, String>> _promptData = [
    {
      'title': '곰둥 이장님',
      'content': '안녕 오시게, 난 평안해를 주름잡는 말해도의 이장, 곰둥이라네.\n자네의 이름은 어떻게 되는가 뚜벅?',
    },
    {
      'title': '곰둥 이장님',
      'content': '웅..멋진 이름이로군 이 곳은 온전히 자네만 있는 섬, __도라네 뚜벅~',
    },
    {
      'title': '곰둥 이장님',
      'content': '말해보래도에서는 얼마든지 속마음을 담은 유리병을 바다로 날려버릴 수 있다네 뚜벅.\n그 유리병이 파도에 쓸려 우리 섬에 도착하면\n나와 우리 섬 주민들이 웅의 유리병에 대한\n답문을 보내줄걸세 뚜벅.',
    },
    {
      'title': '곰둥 이장님',
      'content': '답문을 바라지 않으면 조약돌을 넣어보시게.\n그럼 바다 끝까지 가라앉아 아무도 발견하지\n못하지 뚜벅~',
    },
    {
      'title': '곰둥 이장님',
      'content': '아 참!\n웅이 그렇듯이 가끔 우리 섬 주민들도 유리병을\n날린다네 뚜벅, 답문을 해줘도 되고 모른척해도 된다네 뚜벅~',
    },
    {
      'title': '곰둥 이장님',
      'content': '그럼! 앞으로 어떤 이야기들을 주고받을지 기대되는군 뚜벅~\n웅의 이야기를 기다리겠네.\n그럼 또 보자네 뚜벅~',
    },
  ];

  final List<String> _buttonData = [
    '라고 해!',
    '라고 해!',
    '답문을 바라지 않으면?',
    '답문을 바라지 않으면?',
    '도움이 된다면 언제든지!',
    '좋아 그럼 또 보자!',
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
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFAFE3F2),
              image: DecorationImage(
                image: AssetImage('assets/images/Onboarding_image_${_currentPage + 1}.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: _goToPreviousPage,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
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
          Positioned(
            bottom: 150,
            left: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              constraints: BoxConstraints(
                maxWidth: 1000,
                maxHeight: double.infinity,
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
                  if (_currentPage == 0)
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _promptData[_currentPage]['content'] = '안녕 오시게, 난 평안해를 주름잡는 말해도의 이장, 곰둥이라네.\n자네의 이름은 어떻게 되는가 뚜벅?';
                        });
                      },
                      decoration: InputDecoration(
                        hintText: '내 이름은 (최대 5글자)',
                      ),
                    )
                  else if (_currentPage == 1)
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _promptData[_currentPage]['content'] = '웅..멋진 이름이로군 이 곳은 온전히 자네만 있는 섬, $value 도라네 뚜벅~';
                        });
                      },
                      decoration: InputDecoration(
                        hintText: '(최대 5글자)',
                      ),
                    )
                  else
                    Text(
                      _promptData[_currentPage]['content']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
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
                _buttonData[_currentPage],
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
