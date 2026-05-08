import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';

class UserRepository {
  static final UserRepository instance = UserRepository._single();
  UserRepository._single();

  Future<Map<String, dynamic>> login(String username, String password) async {
    final requestData = {"username": username, "password": password};

    // 1. dio post 요청 (map 변환)
    final response = await dio.post("/login", data: requestData);

    print(response.data);
    return response.data;
  }

  // eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpbWdVcmwiOiIvaW1hZ2VzLzEucG5nIiwic3ViIjoibWV0YWNvZGluZyIsImlkIjoxLCJleHAiOjE3NzgzNzI1NTAsInVzZXJuYW1lIjoic3NhciJ9.dYqN40YBmTtNlv-UpLE6V7btIGqCLvkoEbR-v1tTN8cKwx7rZPsJroKWuIExcFEkqqyJWCkb10NEVFz-io7_Yw

  Future<Map<String, dynamic>> autoLogin(String accessToken) async {
    // 1. dio post 요청 (map 변환)
    final response = await dio.post("/auto/login",
        options: Options(headers: {
          "Authorization": "Bearer $accessToken",
        }));

    print(response.data);

    return response.data;
  }
}
