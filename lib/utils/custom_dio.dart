import 'package:dio/dio.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class CustomDio {
  var _dio;

  //http://54.207.211.41:3000
  //http://192.168.0.107:3000

  CustomDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://54.207.211.41:3000',
        connectTimeout: 10000,
      ),
    );
  }

  Dio get instance => _dio;

  /* CustomDio.withAuthentication() {
    _dio = Dio();
    _dio.interceptors.add(InterceptorsWrapper(
        onRequest: _onRequest, onResponse: _onResponse, onError: _onError));
  }

  Dio get instance => _dio;

  _onRequest(RequestOptions options) async {
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get("token");
    options.headers['Authorization'] = token;*/
    print("--> END ${options.method}");
  }

  _onResponse(Response response) {
    print(
        "<-- ${response.statusCode} ${response.request.baseUrl + response.request.path}");
  }

  _onError(DioError e) {
    print("Error: ${e.error}");
    return e;
  }*/
}
