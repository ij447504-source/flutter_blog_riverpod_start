// DiO가 있는 곳(재사용)

import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: "http://192.168.0.58:8080",
    contentType: "application/json; charset=utf-8",
    validateStatus: (status) => true,
  )
);
