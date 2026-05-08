import 'package:dio/dio.dart';

final dio = Dio(BaseOptions(
  baseUrl: "http://192.168.0.123:8080",
  contentType: "application/json; charset=utf-8",
  // headers: "",
  validateStatus: (status) => true,
));
