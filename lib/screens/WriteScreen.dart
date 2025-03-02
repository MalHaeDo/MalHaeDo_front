import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class WriteScreen extends StatefulWidget {
  @override
  _WriteScreenState createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _sendButtonActive = false;

  final List<String> _messages = [
    '지금 느끼는 감정을 판단하거나 억제하려 하지 말고, 내가 이런 감정을 느끼고 있구나라고 인정해보시게 ',
    '거울을 보며 자신의 표정과 모습을 관찰하고, 그 안에서 떠오르는 감정을 인정하며 수용해보시게',
    '내 감정을 친구에게 설명하듯이 글로 써보며, 스스로를 공감하고 위로하는 연습을 해보시게',
    '평소 자주 느끼는 감정이나 반복되는 상황을 적어보고 그 이유를 탐구해보시게',
    '내가 자주 사용하는 감정 표현(좋다, 싫다 등)을 구체적인 단어로 바꿔보시게',
    '지금의 감정에서 배우거나 얻을 수 있는 교훈이나 긍정적인 점을 적어보시게',
    '감정을 느낀 상황에서 통제할 수 있는 부분과 없는 부분을 구분해 적어보시게',
    '감정을 숨기거나 피하려 하지 말고 그 감정이 내 몸에 어떤 영향을 주는지 관찰하고 적어보시게',
    '지금 느끼는 감정을 한 단어로 표현해보고, 그 감정을 느낀 이유를 구체적으로 적어보시게',
  ];

  String _currentMessage = '';

  @override
  void initState() {
    super.initState();
    _currentMessage = _messages.first;
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

  void _refreshMessage() {
    setState(() {
      _messages.shuffle();
      _currentMessage = _messages.first;
    });
  }

  Future<void> _saveMessage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_message', _textController.text);
  }

  Future<void> _clearMessage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_message');
  }

  void _navigateToAnimation() {
    if (_sendButtonActive) {
      _saveMessage();
      Navigator.pushNamed(context, '/animation');
    }
  }

  Future<bool> _onWillPop() async {
    if (_textController.text.isEmpty) return true;
    return await showDialog(
          context: context,
          builder: _buildExitConfirmationDialog,
        ) ??
        false;
  }

  Widget _buildExitConfirmationDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('작성 중인 편지를 삭제하면 사라집니다. 괜찮을까요?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('아니'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('괜찮아'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('바다에 감정 털어놓기'),
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                if (await _onWillPop()) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            _buildMessageCard(),
            _buildLetterContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCard() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('공둥 이장님', style: TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _refreshMessage,
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(_currentMessage),
          ],
        ),
      ),
    );
  }

  Widget _buildLetterContainer() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: null,
                decoration: InputDecoration(border: InputBorder.none, hintText: '여기에 입력하세요...'),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                inputFormatters: [LengthLimitingTextInputFormatter(1000)],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_textController.text.length}/1000',
                    style: TextStyle(color: _textController.text.length > 900 ? Colors.red : Colors.grey)),
                TextButton(
                  onPressed: _sendButtonActive ? _navigateToAnimation : null,
                  child: Text('흘려보내기',
                      style: TextStyle(color: _sendButtonActive ? Colors.blue : Colors.grey)),
                ),
              ],
            ),
          ],
        ),
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
