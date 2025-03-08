import 'package:dio/src/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:malhaeboredo/core/api_service.dart';
import 'package:malhaeboredo/screens/OnboardingScreen.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void _showGuestConfirmationDialog(BuildContext context, WidgetRef ref) {
    final navigatorContext = context;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {  // 이름을 dialogContext로 변경
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/Profile_gom.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '게스트 이용 시 데이터가 일정 기간 후 \n삭제된다네.\n그래도 진행하겠는가?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(dialogContext),  // dialogContext 사용
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          '아니',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(dialogContext);  // dialogContext 사용하여 모달 닫기

                          final apiService = ref.read(apiServiceProvider);
                          try {
                            final result = await apiService.guestLogin();
                            print('API 응답 결과: $result');

                            final accessToken = result['result']?['accessToken'];

                            // 액세스 토큰 로그에 찍기
                            print('액세스 토큰1: $accessToken'); 

                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('accessToken', accessToken);

                            // 원래 컨텍스트를 사용하여 네비게이션
                            if (navigatorContext.mounted) {  // 컨텍스트가 여전히 유효한지 확인
                              print("이동하려는 페이지: /Onboarding"); // 로그 확인
                              Navigator.pushReplacement(
                                navigatorContext,  // 원래 컨텍스트 사용
                                MaterialPageRoute(builder: (context) => OnboardingScreen()),
                              );
                            }
                          } catch (e) {
                            // 원래 컨텍스트를 사용하여 스낵바 표시
                            if (navigatorContext.mounted) {
                              ScaffoldMessenger.of(navigatorContext).showSnackBar(
                                SnackBar(content: Text("로그인 실패: $e")),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xBF8C6D51),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          '진행할래',
                          style: TextStyle(fontSize: 16, color: Colors.white),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              Transform.translate(
                offset: Offset(0, -100), // 50px 위로 이동
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/Subtitle.png',
                      width: 150,
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                      'assets/images/Logo.png',
                      width: 200,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("준비중입니다!")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEE500),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/KakaoLogin.png',
                    width: 200,
                    height: 50,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => _showGuestConfirmationDialog(context, ref),
                child: const Text(
                  '게스트로 입장하기',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}