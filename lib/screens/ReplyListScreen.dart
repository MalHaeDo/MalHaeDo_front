import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:malhaeboredo/data/repositories/user_repository.dart';

class ReplyListScreen extends StatefulWidget {
  const ReplyListScreen({super.key});

  @override
  State<ReplyListScreen> createState() => _ReplyListScreenState();
}

class _ReplyListScreenState extends State<ReplyListScreen> {
  final bool _isLoading = true;
  final List<ReplyItem> _replyList = [];
  final UserRepository _userRepository = UserRepository();
  
  @override
  void initState() {
    super.initState();
    _fetchReplyList();
  }
  
  Future<List<ReplyItem>> _fetchReplyList() async {
    try {
    final response = await _userRepository.getReplyList();  // API 호출

    if (response['isSuccess'] == true) {
      final List<dynamic> replyListData = response['result']['replyList'];  // replyList 추출
      // 응답 데이터를 ReplyItem 목록으로 변환
      return replyListData.map((item) => ReplyItem.fromJson(item)).toList(); // List<ReplyItem> 변환
    } else {
      throw Exception("답장 목록 조회 실패: ${response['message']}");
    }
  } catch (e) {
    throw Exception("답장 목록 조회 실패: $e");
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Mypage_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios, size: 20),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      '유리병 보관함',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Spacer(),
                    Text(
                      '${_replyList.length}개',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _replyList.length,
                        itemBuilder: (context, index) {
                          final reply = _replyList[index];
                          return _buildReplyCard(reply);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildReplyCard(ReplyItem reply) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                const Text(
                  "요약",
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                  reply.letterSummary,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                  },
                  child: const Text(
                  "삭제",
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 12,
                  ),
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getSenderAvatar(reply.sender),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    reply.replySummary,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(
              children: [
                _getSenderAvatar(reply.sender),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${reply.title}-${reply.singer}",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _getSenderAvatar(String sender) {
    // Map senders to avatar images
    final Map<String, Widget> avatars = {
      'BAEBDURI': const CircleAvatar(
        backgroundColor: Colors.pink,
        radius: 14,
        child: Icon(Icons.favorite, size: 16, color: Colors.white),
      ),
      'DANMOO': const CircleAvatar(
        backgroundColor: Colors.lightBlue,
        radius: 14,
        child: Icon(Icons.water_drop, size: 16, color: Colors.white),
      ),
      'LJANGNAM': const CircleAvatar(
        backgroundColor: Colors.brown,
        radius: 14,
        child: Icon(Icons.pets, size: 16, color: Colors.white),
      ),
    };
    
    return avatars[sender] ?? const CircleAvatar(
      backgroundColor: Colors.grey,
      radius: 14,
      child: Icon(Icons.person, size: 16, color: Colors.white),
    );
  }
}

class ReplyItem {
  final int replyId;
  final String replySummary;
  final String letterSummary;
  final String sender;
  final String title;
  final String singer;
  
  ReplyItem({
    required this.replyId,
    required this.replySummary,
    required this.letterSummary,
    required this.sender,
    required this.title,
    required this.singer,
  });
  
  factory ReplyItem.fromJson(Map<String, dynamic> json) {
    return ReplyItem(
      replyId: json['replyId'] as int,
      replySummary: json['replySummary'] as String,
      letterSummary: json['letterSummary'] as String,
      sender: json['sender'] as String,
      title: json['title'] as String,
      singer: json['singer'] as String,
    );
  }
}