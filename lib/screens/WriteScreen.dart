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
                'assets/images/bottle.png',
                width: 60,
                height: 60,
              ),
            ),
            // Confirmation text
            Text(
              '작성중인 편지를 삭제하면\n다 시작하는데 괜찮을까?',
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
            onTap: _sendButtonActive ? _navigateToAnimation : null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _sendButtonActive ? Color(0xFFA0622E).withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
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