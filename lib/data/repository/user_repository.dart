import 'package:flutter_blog/_core/utils/my_http.dart';

class UserRepository {
  static final UserRepository instance = UserRepository._single();

  UserRepository._single();

  Future<Map<String, dynamic>> login(String username, String password) async {
    // 1. dio post 요청(map으로 변환)
    final requestData = {"username": username, "password": password};

    final response = await dio.post("/login", data: requestData);

    return response.data;
  }
}
