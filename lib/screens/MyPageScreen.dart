import 'package:flutter/material.dart';
import 'package:malhaeboredo/core/api_service.dart';
import 'package:malhaeboredo/data/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:malhaeboredo/widgets/MyPageModal.dart';

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
  late int letterId = 0;

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
      final response = await _apiService.userProfile(_userName, _islandName);
      setState(() {
        _userName = response['userNickname'];
        _islandName = response['userIslandName'];
        print(_userName);
        print(_islandName);
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
      final response = await _apiService.getRepliesByLetterId(letterId);
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
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // 위에서 20px 띄우기
        crossAxisAlignment: CrossAxisAlignment.center, // 가로 중앙 정렬
        children: [
          SizedBox(height: 20), // 위에서 20px 띄우기
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "마이페이지",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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


  // Build counter section (sent and replied count)
  Widget _buildCounters() {
  return Padding(
    padding: const EdgeInsets.only(left: 16.0, right: 16.0), // 좌우 패딩만 설정
    child: Align(
      alignment: Alignment.topCenter,  // 상단 중앙으로 정렬
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, 
        children: [
          SizedBox(height: 180),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, 
              children: [
                Image.asset('assets/images/box.png', width: 50, height: 50), 
                const SizedBox(height: 8),
                Text('$_sentCount개', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(width: 20), 
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, 
              children: [
                Image.asset('assets/images/full_bottle.png', width: 50, height: 50), 
                const SizedBox(height: 8),
                Text('$_repliedCount개', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
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
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20), // padding 줄임
      decoration: BoxDecoration(
        color: const Color(0xFFBB8863).withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$_islandName에 $_userName주민",
            style: const TextStyle(color: Colors.white, fontSize: 14), // 폰트 크기 줄임
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
    child: TextButton(
      onPressed: () {
        IslandNameDialog();
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero, // 패딩 제거 (아이콘과 텍스트가 붙게)
      ),
      child: Row(
        children: [
          Icon(Icons.refresh, color: Colors.white, size: 16),
          SizedBox(width: 4),
          Text("수정하기", style: TextStyle(color: Colors.white)),
        ],
      ),
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
          color: Colors.transparent,
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
      style: TextButton.styleFrom(backgroundColor: Colors.transparent), // 배경 제거
      child: const Center(
        child: Text("도움말", style: TextStyle(fontSize: 14, color: Colors.black)),
      ),
    ),
  );
}

Widget _buildLogoutButton() {
  return Expanded(
    child: TextButton(
      onPressed: () => _showLogoutDialog(),
      style: TextButton.styleFrom(backgroundColor: Colors.transparent), // 배경 제거
      child: const Center(
        child: Text("로그아웃", style: TextStyle(fontSize: 14, color: Colors.black)),
      ),
    ),
  );
}

Widget _buildDeleteButton() {
  return Expanded(
    child: TextButton(
      onPressed: () => _showDeleteUserDialog(),
      style: TextButton.styleFrom(backgroundColor: Colors.transparent), // 배경 제거
      child: const Center(
        child: Text("탈퇴", style: TextStyle(fontSize: 14, color: Colors.black)),
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
        titlePadding: const EdgeInsets.all(16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        backgroundColor: const Color(0xFFF8F1E7),  // Light beige background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "이용약관",
              style: TextStyle(
                color: Color(0xFFB97D4E),  // Brown/orange text color
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "개인정보처리방침",
              style: TextStyle(
                color: Color(0xFFB97D4E),  // Brown/orange text color
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.black87),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
        actionsPadding: EdgeInsets.zero,
        actionsAlignment: MainAxisAlignment.center,
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
                    'assets/images/Profile_gom.png',
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
                child: Center(
                  child: Image.asset(
                    'assets/images/Profile_gom.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Text
              const Text(
                '진짜 떠날껀가? \n자네의 흔적이 모두 없어질 수 있다네..',
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

