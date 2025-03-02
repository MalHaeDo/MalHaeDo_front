import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WriteScreen extends StatefulWidget {
  @override
  _WriteScreenState createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _sendButtonActive = false;
  bool _handleClick = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _sendButtonActive = _textController.text.isNotEmpty;
      });
    });
  }

  void _handleButtonClick() {
    setState(() {
      _handleClick = true;
    });
  }

  final List<String> _messages = [
    '지금 느끼는 감정을 판단하거나 억제하려 하지 말고, 내가 이런 감정을 느끼고 있구나라고 인정해보시게 \n나는 지금 슬픔을 느끼고 있구나.',
    '거울을 보며 자신의 표정과 모습을 관찰하고, 그 안에서 떠오르는 감정을 인정하며 수용해보시게 \n지금 내 표정이 피곤해 보이지만, 그 모습도 나의 일부다.',
    '내 감정을 친구에게 설명하듯이 글로 써보며, 스스로를 공감하고 위로하는 연습을 해보시게 \n오늘 너무 속상했어. 하지만 이런 기분을 느낄 수도 있는 거니까 괜찮아.',
    '평소 자주 느끼는 감정이나 반복되는 상황을 적어보고 그 이유를 탐구해보시게 \n사람 많은 곳에 가면 자꾸 불편하고 초조한 기분이 든다. 혼잡한 환경에서 에너지가 빨리 소진되는 것 같다.',
    '내가 자주 사용하는 감정 표현(좋다, 싫다 등)을 구체적인 단어로 바꿔보시게 \n좋다 → 기쁘다, 만족스럽다 / 싫다 → 짜증난다, 답답하다.',
    '지금의 감정에서 배우거나 얻을 수 있는 교훈이나 긍정적인 점을 적어보시게 \n이번 실망을 통해 더 강해지고, 내 안의 내성을 키울 수 있는 기회가 된거다.',
    '감정을 느낀 상황에서 통제할 수 있는 부분과 없는 부분을 구분해 적어보시게 \n내 기분은 통제할 수 있지만 친구의 행동과 생각은 내 의지로 다스릴 수 없다.',
    '감정을 숨기거나 피하려 하지 말고 그 감정이 내 몸에 어떤 영향을 주는지 관찰하고 적어보시게 \n스트레스가 느껴진다. 심장이 두근거리고, 목과 어깨가 뻐근하게 긴장된 느낌이다.',
    '지금 느끼는 감정을 한 단어로 표현해보고, 그 감정을 느낀 이유를 구체적으로 적어보시게 \n화남. 친구가 약속을 어겼고, 나를 존중하지 않는 것 같아서 기분이 나쁘다.',
  ];

  String _currentMessage = '지금 느끼는 감정을 판단하거나 억제하려 하지 말고, 내가 이런 감정을 느끼고 있구나라고 인정해보시게 \n나는 지금 슬픔을 느끼고 있구나.';

  void _refreshMessage() {
    setState(() {
      _currentMessage = (_messages..shuffle()).first;
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

  // Navigate to animation screen with the message
  void _navigateToAnimation() {
    if (_textController.text.isNotEmpty) {
      _saveMessage();
      Navigator.pushNamed(context, '/animation');
    }
  }

  // Show confirmation dialog when trying to exit
  Future<bool> _onWillPop() async {
    if (_textController.text.isEmpty) {
      return true; // Allow pop if no text entered
    }

    // Show confirmation dialog
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _buildExitConfirmationDialog(context),
    );

    return result ?? false; // Default to false if dialog is dismissed
  }

  Widget _buildExitConfirmationDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Message bottle image
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Image.asset(
                'assets/images/full_bottle.png',
                width: 60,
                height: 60,
              ),
            ),
            // Confirmation text
            Text(
              '작성중인 편지를 삭제하면\n다 사라지는데 괜찮을까?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 25),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // No button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      '아니',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // Yes button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Color(0xFFA0622E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      '괜찮아',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
            '바다에 감정 털어놓기',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () async {
              if (_textController.text.isEmpty) {
                Navigator.pop(context);
              } else {
                final shouldPop = await _onWillPop();
                if (shouldPop) {
                  Navigator.pop(context);
                }
              }
            },
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
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.white, size: 20),
                  onPressed: _refreshMessage,
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              _currentMessage,
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
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Fixed background paper
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/paper.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Letter content with separate scrolling
            Column(
              children: [
                _buildScrollableTextInput(),
                _buildFooter(),
                _buildBottleIcon(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableTextInput() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1000),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Send button with text and icon combined
          GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: _handleClick ? Colors.brown : Colors.grey,
                    size: 20,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '흘려보내기',
                    style: TextStyle(
                      color: _handleClick ? Colors.brown : Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                ],
              ),
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
    return GestureDetector(
      onTap: _sendButtonActive ? _navigateToAnimation : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: _sendButtonActive ? Color(0xBFA0622E) : Colors.grey,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(8),
        child: Image.asset(
          _sendButtonActive ? 'assets/images/full_bottle.png' : 'assets/images/bottle.png',
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}
