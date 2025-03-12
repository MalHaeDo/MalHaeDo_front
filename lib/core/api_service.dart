import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio(
    BaseOptions(
      baseUrl: "http://malhaedo-server.shop/api/v0",
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
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
        print("📡 [API 요청] ${options.method} ${options.uri}");
        print("📝 [헤더] ${options.headers}");
        print("📦 [데이터] ${options.data}");
        options.extra['noCache'] = true;
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
    // 기존 액세스 토큰 삭제
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken'); // 이전 토큰 삭제

    // 게스트 로그인 요청
    final response = await _dio.get("/member/signup/guest");

    var data = response.data as Map<String, dynamic>;
    print('API 응답: $data');

    final accessToken = data['result']?['accessToken'];
    print('액세스 토큰: $accessToken');

    if (accessToken != null) {
      // 새로운 액세스 토큰 저장
      await prefs.setString('accessToken', accessToken);
      print("새 액세스 토큰 저장됨: $accessToken");

      return data; // 응답 반환
    } else {
      throw Exception("accessToken이 응답에 없음");
    }
  } catch (e) {
    // 오류 발생 시
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
      // /reissue/access-token API 요청
      final response = await _dio.post("/reissue/access-token");

      // 새로운 토큰을 SharedPreferences에 저장
      final prefs = await SharedPreferences.getInstance();
      
      // 기존 토큰 삭제
      await prefs.remove('accessToken');
      
      // 새로운 토큰 저장
      await prefs.setString('accessToken', response.data['result']['accessToken']);

      return response.data;
    } catch (e) {
      throw Exception("토큰 재발급 실패");
    }
  }

// 401 오류를 처리하는 방법
  Future<void> handle401Error(DioException error) async {
    if (error.response?.statusCode == 401) {
      // 401 에러가 발생했을 때, 액세스 토큰을 재발급 받음
      try {
        final newTokenData = await reissueAccessToken();
      } catch (e) {
        print("토큰 재발급 실패");
      }
    }
  }


  // ✅ 8. 특정 편지에 대한 답장 조회
  Future<Map<String, dynamic>> getRepliesByLetterId(int letterId) async {
    try {
      final response = await _dio.get("/reply/$letterId");
      print("응답 상태 코드: ${response.statusCode}");
      print("답: $response");
      print("답: ${response.data}");
      return response.data;
    } catch (e) {
      print("오류: $e");
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
  Future<void> deleteReply(int replyId) async {
    try {
      await _dio.delete("/reply/$replyId/delete");
    } catch (e) {
      throw Exception("답장 삭제 실패");
    }
  }

  // ✅ 12. 추천하기
  Future<Map<String, dynamic>> recommendLetter(int letterId) async {
  try {
    // API 호출
    final response = await _dio.get("/recommed/$letterId");

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
