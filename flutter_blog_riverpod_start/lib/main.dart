import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/move.dart';
import 'package:flutter_blog/_core/constants/theme.dart';
import 'package:flutter_blog/splash_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 현재 화면 컨텍스트 글로벌하게 관리하는 객체체
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey:
          navigatorKey, // context가 없는 곳에서 context를 사용할 수 있는 방법 (몰라도 됨)
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      // initialRoute: Move.LoginPage
      routes: getRouters(),
      theme: theme(),
    );
  }
}
