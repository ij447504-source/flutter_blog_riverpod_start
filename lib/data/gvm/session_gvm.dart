// 1. 창고데이터
import 'package:flutter_blog/_core/utils/my_device.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
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
  //오타방지를 위한 객체생성, 하지만 이렇게 적는거보단 리스폰스에 있는 것을 꺼내서 리턴해주는 것이 훨 좋음
} // 젤 처음 로그인 안된상태로 초기화

// 2. 창고
class SessionGVM extends Notifier<SessionUser> {
  UserRepository userRepository = UserRepository.instance;

  @override
  SessionUser build() {
    return SessionUser();
  }

  Future<void> login(String username, String password) async {
    final map = await userRepository.login(username, password);
    final response = map["response"];
    if (response is! Map<String, dynamic>) {
      throw Exception("Unexpected login response: $map");
    }

    state = SessionUser.fromMap(response); // 상태를 계속 담아두고 사용가능

    //1. 디바이스 저장
    secureStorage.write(key: "accessToken", value: state.accessToken);

    //2. DIO 세팅
    dio.options.headers["Authorization"] = "Bearer ${state.accessToken}";
  }

  Future<void> logout() async {
    state = SessionUser();

    //1. 디바이스 저장
    await secureStorage.delete(key: "accessToken");
    //2. DIO 세팅
    dio.options.headers["Authorization"] = "";
  }
}

// 3. 창고관리자
final sessionProvider =
    NotifierProvider<SessionGVM, SessionUser>(() => SessionGVM());
