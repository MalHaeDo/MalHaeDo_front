import 'package:flutter/material.dart';
import 'package:malhaeboredo/core/api_service.dart';
import 'package:malhaeboredo/data/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final ApiService _apiService = ApiService();
  late Map<String, dynamic> _userProfile;
  late List<Map<String, dynamic>> _replyList;
  late List<Map<String, dynamic>> _writeList;
  late int _sentCount = 0;
  late int _repliedCount = 0;
  late String _userName = '';
  late String _islandName = '';
  late List<Map<String, dynamic>> _bottleData = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadReplyList();
    _loadReplyStorage();
    _fetchBottleData();
  }

  Future<void> _loadUserData() async {
    try {
      final response = await _apiService.userProfile("userNickname", "userIslandName");
      setState(() {
        _userName = response['userNickname'];
        _islandName = response['userIslandName'];
      });
    } catch (e) {
      print("Error loading user profile: $e");
    }
  }

  Future<void> _loadReplyStorage() async {
    try {
      final response = await _apiService.getReplyStorage();
      if (response['isSuccess'] == true) {
        setState(() {
          _sentCount = response['result']['sentCount'];
          _repliedCount = response['result']['repliedCount'];
        });
      } else {
        throw Exception("Failed to load reply storage: ${response['message']}");
      }
    } catch (e) {
      print("Error loading reply storage: $e");
    }
  }

  Future<void> _loadReplyList() async {
    try {
      final response = await _apiService.getReplyList();
      setState(() {
        _replyList = response['replyList'];
      });
    } catch (e) {
      print("Error loading reply list: $e");
    }
  }

  Future<void> _logout() async {
    try {
      await _apiService.logout();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      Navigator.pop(context);
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  Future<void> _deleteUser() async {
    try {
      await _apiService.deleteUser();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      Navigator.pop(context);
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  void _onBottleClick(int replyId) {
    Navigator.pushNamed(context, '/replyDetail');
  }

  Future<void> _fetchBottleData() async {
    try {
      final response = await _apiService.getRepliesByLetterId("letterId");
      if (response['isSuccess'] == true) {
        setState(() {
          _bottleData = response['result']['bottleData'];
        });
      } else {
        throw Exception("Failed to fetch bottle data: ${response['message']}");
      }
    } catch (e) {
      print("Error fetching bottle data: $e");
    }
  }

  List<Positioned> _generateBottlePositions() {
    return _bottleData.map((bottle) {
      final replyId = bottle['replyId'];
      return Positioned(
        left: bottle['left'],
        top: bottle['top'],
        child: GestureDetector(
          onTap: () => _onBottleClick(replyId),
          child: Image.asset(
            'assets/images/bottle.png',
            width: 50,
            height: 70,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bottlePositions = _generateBottlePositions();

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildTitle(),
          _buildCounters(),
          ...bottlePositions,
          _buildBottomNav(),
          _buildBottomTabBar(screenWidth),
        ],
      ),
    );
  }

  // Build background
  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Mypage_image.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Build title and back button
  Widget _buildTitle() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            const Text(
              "마이페이지",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Build counter section (sent and replied count)
  Widget _buildCounters() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 80.0, left: 16.0, right: 16.0),
        child: Column(
          children: [
            _buildCounterRow('assets/images/box.png', '$_sentCount개'),
            const SizedBox(height: 16),
            _buildCounterRow('assets/images/bottle.png', '$_repliedCount개', noReplyText: _repliedCount == 0 ? "답장이 없습니다" : null),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterRow(String iconPath, String text, {String? noReplyText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(iconPath, width: 30, height: 30),
        Text(text, style: const TextStyle(fontSize: 16)),
        if (noReplyText != null) Text(noReplyText, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  // Build bottom navigation section
  Widget _buildBottomNav() {
    return Positioned(
      bottom: 80,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFBB8863).withOpacity(0.8),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$_islandName에 $_userName주인",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            _buildEditButton(),
          ],
        ),
      ),
    );
  }

  // Build edit button in bottom navigation
  Widget _buildEditButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.refresh, color: Colors.white, size: 16),
          SizedBox(width: 4),
          Text("수정하기", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  // Build bottom tab bar
  Widget _buildBottomTabBar(double screenWidth) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildHelpButton(),
            _buildLogoutButton(),
            _buildDeleteButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpButton() {
    return Expanded(
      child: TextButton(
        onPressed: () => _showHelpDialog(),
        child: const Center(
          child: Text("도움말", style: TextStyle(fontSize: 14)),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Expanded(
      child: TextButton(
        onPressed: () => _showLogoutDialog(),
        child: const Center(
          child: Text("로그아웃", style: TextStyle(fontSize: 14, color: Colors.blue)),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Expanded(
      child: TextButton(
        onPressed: () => _showDeleteUserDialog(),
        child: const Center(
          child: Text("탈퇴", style: TextStyle(fontSize: 14)),
        ),
      ),
    );
  }

  // Show help dialog
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("도움말"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("이용약관"),
              SizedBox(height: 8),
              Text("개인정보 처리방침"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("닫기"),
            ),
          ],
        );
      },
    );
  }

  // Show logout confirmation dialog
  void _showLogoutDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFF8EFE9),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Character Image
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF333333),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/character.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Text
              const Text(
                '나중에 돌아올텐가?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 20),
              
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        side: const BorderSide(
                          color: Color(0xFFCCBDAD),
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _logout();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB78A6D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        '확인',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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
    },
  );
}

  // Show delete user confirmation dialog
  void _showDeleteUserDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFF8EFE9),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Character Image
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF333333),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/character.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Text
              const Text(
                '나중에 돌아올텐가?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 20),
              
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        side: const BorderSide(
                          color: Color(0xFFCCBDAD),
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _deleteUser();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB78A6D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        '확인',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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
    },
  );
}
}
