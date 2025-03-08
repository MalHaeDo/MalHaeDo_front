import 'package:dio/src/dio.dart';
import 'package:malhaeboredo/core/api_service.dart';


class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> kakaoLogin(String accessToken) {
   return _apiService.kakaoLogin(accessToken); 
  } 

  Future<Map<String, dynamic>> guestLogin() {
    return _apiService.guestLogin();
  }

  Future<Map<String, dynamic>> getUserInfo() {
    return _apiService.getUserInfo();
  }

  Future<void> logout() {
    return _apiService.logout();
  }

  Future<Map<String, dynamic>> reissueAccessToken() async {
    return _apiService.reissueAccessToken();
  }

}