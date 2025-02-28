import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WriteScreen extends StatefulWidget {
  @override
  _WriteScreenState createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _sendButtonActive = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _sendButtonActive = _textController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _saveMessage() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('saved_message', _textController.text);
}

void _clearMessage() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('saved_message');
}

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
              _buildHeader(context),
              _buildMessageCard(),
              _buildLetterContainer(),
              _buildBottomButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'To_평안해',
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
    );
  }

  Widget _buildMessageCard() {
    return Card(
      color: Color(0xBFFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '공둥 이장님',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                Icon(Icons.refresh, color: Colors.white, size: 20),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '지금 느끼는 감정을 판단하거나 억제하려 하지 말고,\n'
              '내가 이런 감정을 느끼고 있구나 라고 인정해보시게.',
              style: TextStyle(
                color: Colors.brown,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLetterContainer() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/paper.png'),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            _buildTextInput(),
            _buildFooter(),
            _buildBottleIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        child: TextField(
          controller: _textController,
          maxLines: null,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '',
            contentPadding: EdgeInsets.zero,
          ),
          style: TextStyle(
            fontSize: 16,
            height: 1.8,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Row(
            children: [
              Icon(
              Icons.check_circle_outline,
                color: _sendButtonActive ? Colors.brown : Colors.grey,
              size: 20,
              ),
              SizedBox(width: 4),
              ElevatedButton(
              onPressed: _sendButtonActive
                ? () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Color(0xBFA0622E),
                      title: Text(
                      '메시지를 바다에 흘려보낼까요?',
                      style: TextStyle(color: Colors.white),
                      ),
                      actions: [
                      TextButton(
                        child: Text(
                        '취소',
                        style: TextStyle(color: Colors.white70),
                        ),
                        onPressed: () {
                        Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text(
                        '흘려보내기',
                        style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                        _saveMessage();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop(true);
                        setState(() {
                          _sendButtonActive = false;
                        });
                        },
                      ),
                      ],
                    );
                    },
                  );
                  }
                : null,
              child: Text(
                '흘려보내기',
                style: TextStyle(
                color: _sendButtonActive ? Colors.brown : Colors.grey,
                fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              ),
            ],
          ),
          Spacer(),
          Text(
            '${_textController.text.length}/1000',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottleIcon() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xBFA0622E),
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(8),
      child: Image.asset(
        _sendButtonActive ? 'assets/images/full_bottle.png' : 'assets/images/bottle.png',
        width: 50,
        height: 50,
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ElevatedButton(
        onPressed: _sendButtonActive
            ? () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Color(0xBFA0622E),
                      title: Text(
                        '메시지를 바다에 흘려보낼까요?',
                        style: TextStyle(color: Colors.white),
                      ),
                      actions: [
                        TextButton(
                          child: Text(
                            '취소',
                            style: TextStyle(color: Colors.white70),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            '흘려보내기',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop(true);
                            setState(() {
                              _sendButtonActive = false;
                            });
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            : null,
        child: Text(
          '흘려보내기',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _sendButtonActive ? Color(0xBFA0622E) : Colors.grey,
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
