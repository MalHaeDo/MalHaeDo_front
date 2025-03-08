import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio(
    BaseOptions(
      baseUrl: "http://malhaedo-server.shop/api/v0",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  ) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('accessToken');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print("API 오류 발생: ${e.response?.data}");
        return handler.next(e);
      },
    ));
  }

  // ✅ 1. 카카오 로그인
  Future<Map<String, dynamic>> kakaoLogin(String accessToken) async {
    try {
      final response = await _dio.post("/auth/kakao", data: {
        "accessToken": accessToken,
      });

      // 토큰 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', response.data['result']['accessToken']);

      return response.data;
    } catch (e) {
      throw Exception("카카오 로그인 실패");
    }
  }

  // 프로필 설정 및 수정 API
  Future<Map<String, dynamic>> userProfile(String nickName, String islandName) async {
    try {
      // API 호출
      final response = await _dio.post(
        "/member/profile", // API 엔드포인트
        data: {
          "nickName": nickName, // 요청 본문에 nickname
          "islandName": islandName, // 요청 본문에 islandName
        },
      );

      // 응답 처리
      if (response.statusCode == 200) {
        // 성공적으로 응답 받았을 경우
        return response.data; // 응답 데이터를 반환
      } else {
        // 실패한 경우
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      // 예외 처리
      print('Error: $e');
      throw Exception('Failed to update profile');
    }
  }


  // ✅ 2. 게스트 로그인
  Future<Map<String, dynamic>> guestLogin() async {
  try {
    final response = await _dio.post("/member/signup/guest");

    // 응답 데이터를 명시적으로 Map으로 캐스팅
    var data = response.data as Map<String, dynamic>;

    // 데이터 로그 확인
    print('API 응답: $data');

    // accessToken 추출
    final accessToken = data['result']?['accessToken'];

    // 액세스 토큰 로그 찍기
    print('액세스 토큰: $accessToken');

    if (accessToken != null) {
      final prefs = await SharedPreferences.getInstance();
      String? storedToken = prefs.getString('accessToken');
      print('저장된 액세스 토큰: $storedToken');
      return data; // 응답 반환
    } else {
      throw Exception("accessToken이 응답에 없음");
    }
  } catch (e) {
    print('게스트 로그인 실패: $e');
    throw Exception("게스트 로그인 실패");
  }
}

  // ✅ 3. 사용자 정보 가져오기
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final response = await _dio.get("/member/info");
      return response.data;
    } catch (e) {
      throw Exception("사용자 정보 가져오기 실패");
    }
  }

  // ✅ 4. 로그아웃
  Future<void> logout() async {
    try {
      await _dio.post("/member/logout");
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken'); // ✅ 토큰 삭제
    } catch (e) {
      throw Exception("로그아웃 실패");
    }
  }

  // ✅ 5. 회원 탈퇴
  Future<void> deleteUser() async {
    try {
      await _dio.delete("/member/delete");
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken'); // ✅ 토큰 삭제
    } catch (e) {
      throw Exception("회원 탈퇴 실패");
    }
  }

  // ✅ 6. 편지 보내기
  Future<Map<String, dynamic>> sendLetter(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post("/letter/send", data: data);
      return response.data;
    } catch (e) {
      throw Exception("편지 전송 실패");
    }
  }

  // ✅ 7. 액세스 토큰 재발급
  Future<Map<String, dynamic>> reissueAccessToken() async {
    try {
      final response = await _dio.post("/reissue/access-token");

      // 새로운 토큰 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', response.data['result']['accessToken']);

      return response.data;
    } catch (e) {
      throw Exception("토큰 재발급 실패");
    }
  }

  // ✅ 8. 특정 편지에 대한 답장 조회
  Future<Map<String, dynamic>> getRepliesByLetterId(String letterId) async {
    try {
      final response = await _dio.get("/reply/$letterId");
      return response.data;
    } catch (e) {
      throw Exception("답장 가져오기 실패");
    }
  }

  // ✅ 9. 답장 보관함 조회
  Future<Map<String, dynamic>> getReplyStorage() async {
    try {
      final response = await _dio.get("/reply/storage");
      return response.data;
    } catch (e) {
      throw Exception("답장 보관함 조회 실패");
    }
  }

  // ✅ 10. 전체 답장 목록 조회
  Future<Map<String, dynamic>> getReplyList() async {
    try {
      final response = await _dio.get("/reply/list");
      return response.data;
    } catch (e) {
      throw Exception("답장 목록 조회 실패");
    }
  }

  // ✅ 11. 특정 답장 삭제
  Future<void> deleteReply(String replyId) async {
    try {
      await _dio.delete("/reply/$replyId/delete");
    } catch (e) {
      throw Exception("답장 삭제 실패");
    }
  }

  // ✅ 12. 추천하기
  Future<Map<String, dynamic>> recommendLetter(String letterId) async {
  try {
    // API 호출
    final response = await _dio.post("/recommed/$letterId");

    // 응답 처리
    if (response.statusCode == 200) {
      final data = response.data;

      if (data['isSuccess'] == true) {
        return {
          'isSuccess': true,
          'title': data['result']['title'],
          'singer': data['result']['singer'],
          'songId': data['result']['songId'],
          'reason': data['result']['reason'],
          'url': data['result']['url'],
        };
      } else {
        throw Exception("추천 실패: ${data['message']}");
      }
    } else {
      throw Exception("API 요청 실패: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("추천 실패: $e");
  }
}
}
