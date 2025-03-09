import 'package:dio/src/dio.dart';
import 'package:malhaeboredo/core/api_service.dart';

class UserRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> sendLetter(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.sendLetter(data);  

      if (response['isSuccess'] == true) {
        return {
          'isSuccess': true,
          'message': response['message'],
          'letterId': response['result']['letterId'],
        };
      } else {
        throw Exception("편지 전송 실패: ${response['message']}");
      }
    } catch (e) {
      throw Exception("편지 전송 실패: $e");
    }
  }

  Future<Map<String, dynamic>> getRepliesByLetterId(int letterId) async {
    try {
      final response = await _apiService.getRepliesByLetterId(letterId);  // API 호출

      if (response['isSuccess'] == true) {
        return {
          'isSuccess': true,
          'message': response['message'],
          'replyId': response['result']['replyId'],
          'sender': response['result']['sender'],
          'content': response['result']['content'],
        };
      } else {
        throw Exception("답장 가져오기 실패: ${response['message']}");
      }
    } catch (e) {
      throw Exception("답장 가져오기 실패: $e");
    }
  }

  Future<Map<String, dynamic>> getReplyStorage() async {
    try {
      final response = await _apiService.getReplyStorage();  // API 호출

      if (response['isSuccess'] == true) {
        return {
          'isSuccess': true,
          'message': response['message'],
          'sentCount': response['result']['sentCount'],
          'repliedCount': response['result']['repliedCount'],
        };
      } else {
        throw Exception("답장 보관함 조회 실패: ${response['message']}");
      }
    } catch (e) {
      throw Exception("답장 보관함 조회 실패: $e");
    }
  }

  Future<Map<String, dynamic>> getReplyList() async {
    try {
      final response = await _apiService.getReplyList();  // API 호출

      if (response['isSuccess'] == true) {
        return {
          'isSuccess': true,
          'message': response['message'],
          'replyList': List<Map<String, dynamic>>.from(
            response['result']['replyList'].map((reply) => {
              'replyId': reply['replyId'],
              'summary': reply['summary'],
              'sender': reply['sender'],
              'title': reply['title'],
              'singer': reply['singer'],
            }),
          ),
          'totalElements': response['result']['totalElements'],
        };
      } else {
        throw Exception("답장 목록 조회 실패: ${response['message']}");
      }
    } catch (e) {
      throw Exception("답장 목록 조회 실패: $e");
    }
  }

  Future<void> deleteReply(String replyId) async {
    try {
      await _apiService.deleteReply(replyId);  // API 호출
    } catch (e) {
      throw Exception("답장 삭제 실패: $e");
    }
  }

  Future<Map<String, dynamic>> recommendLetter(String letterId) async {
    try {
      final response = await _apiService.recommendLetter(letterId);

      // API 응답이 성공적인지 확인하고, 성공적인 데이터를 반환
      if (response['isSuccess'] == true) {
        return {
          'isSuccess': true,
          'title': response['result']['title'],
          'singer': response['result']['singer'],
          'songId': response['result']['songId'],
          'reason': response['result']['reason'],
          'url': response['result']['url'],
        };
      } else {
        throw Exception("추천 실패: ${response['message']}");
      }
    } catch (e) {
      throw Exception("추천 실패: $e");
    }
  }
}