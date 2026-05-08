// 1. 창고데이터
import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/move.dart';
import 'package:flutter_blog/_core/utils/my_device.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionUser {
  int? id;
  String? username;
  String? imgUrl;
  String? accessToken;
  bool isLogin;

  SessionUser(
      {this.id,
      this.username,
      this.imgUrl,
      this.accessToken,
      this.isLogin = false});
  SessionUser.fromMap(Map<String, dynamic> m)
      : id = m["id"],
        username = m["username"],
        imgUrl = m["imgUrl"],
        accessToken = m["accessToken"],
        isLogin = true;
}

// 2. 창고
class SessionGVM extends Notifier<SessionUser> {
  UserRepository userRepository = UserRepository.instance;
  final mContext = navigatorKey.currentContext!;

  @override
  SessionUser build() {
    return SessionUser();
  }

  Future<void> autoLogin() async {
    // 디바이스에 토큰이 있는걸 자져오기
    final accessToken = await secureStorage.read(key: "accessToken");
    print("autoLogin: $accessToken");
    // 2. 토큰이 있다면 없다면

    // 3-1. 있다면 user_repository -> autoLogin
    if (accessToken != null) {
      final response = await userRepository.autoLogin(accessToken);
      print("response : $response");
      if (response["success"] == true) {
        print("자동 로그인 성공 ----------------------");
        // 상태 갱신
        state = SessionUser.fromMap(response["response"]);
        // dio 세팅 인터셉터로 하는게 좋음음
        dio.options.headers["Authorization"] = state.accessToken;
        // 화면이동 (비지니스 책임 위배!!!)
        Navigator.pushNamed(mContext, Move.postListPage);
      }
    } else {
      // 3-2. 없다면 로그인 페이지로 이동동
    }
  }

  Future<void> login(String username, String password) async {
    final response = await userRepository.login(username, password);
    state = SessionUser.fromMap(response["response"]);

    // 1. 디바이스 저장
    secureStorage.write(key: "accessToken", value: state.accessToken);

    // 2. DIO 세팅
    dio.options.headers["Authorization"] = state.accessToken;
  }

  Future<void> logOut() async {
    state = SessionUser();

    //
    await secureStorage.delete(key: "accessToken");

    dio.options.headers["Authorization"] = "";
  }
}

// 3. 창고관리자
final sessionProvider =
    NotifierProvider<SessionGVM, SessionUser>(() => SessionGVM());
