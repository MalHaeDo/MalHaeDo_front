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
            GestureDetector(
            onTap: _sendButtonActive ? _saveMessage : null,
            child: Row(
              children: [
              Icon(
                Icons.check_circle_outline,
                color: _sendButtonActive ? Colors.brown : Colors.grey,
                size: 20,
              ),
              SizedBox(width: 4),
                Text(
                '흘려보내기',
                style: TextStyle(
                  color: _sendButtonActive ? Colors.brown : Colors.grey,
                  fontSize: 14,
                ),
                ),
                if (_sendButtonActive)
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: Colors.brown),
                  onPressed: () {
                  Navigator.pushNamed(context, '/animation');
                  },
                ),
              ],
            ),
            ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_textController.text.length}/1000',
                style: TextStyle(
                  color: _textController.text.length > 900 ? Colors.red : Colors.grey,
                  fontSize: 14,
                ),
              ),
              if (_textController.text.length > 900)
                Text(
                  '최대 1000자까지 입력할 수 있습니다.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
            ],
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
}
  
