import 'package:my_wallet/app_config.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

const String apiKey = '5d2300c2c69d24a09cf5b09b';
const String token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IldCZVpUNlZ1c041d041WWo0bHdQUWtQSzdVOXVKRnBRWUdaOUN2UU1aZDg1RGVxdzFOaHpXYlloTUFpZVlkRWciLCJ1c2VySWQiOiI2MjkyNzgyZWQyYzdlNDAwNThiYWQyZTAiLCJyb2xlcyI6WyJHVUVTVCJdLCJwcm9maWxlcyI6W3siaWQiOiI2MjkyNzgyZWQyYzdlNDAwNThiYWQyZTEiLCJhZ2UiOjEzLCJtcGFhIjp7ImlkIjoiNWQyM2UxMjU5NTI1MWI5OGJkMDQzMzc2IiwiYWdlIjoxM319LHsiaWQiOiI2MjkyNzgyZWQyYzdlNDAwNThiYWQyZTIiLCJhZ2UiOjcsIm1wYWEiOnsiaWQiOiI1ZDIzZTFlMjk1MjUxYjk4YmQwNDM0MWQiLCJhZ2UiOjd9fV0sImlhdCI6MTY1Mzc2NjE5MCwiZXhwIjoxOTY5MTI2MTkwfQ.CK2XFxPT7f48xgsuJttz3bA3ueaRZ1Veu_EoyBe5iHE';

class AppDio with DioMixin implements Dio {
  AppDio._({BaseOptions? options}) {
    options = BaseOptions(
      baseUrl: AppConfig.instance.baseUrl,
      headers: {"Authorization": token, "api-key": apiKey},
      contentType: 'application/json',
      connectTimeout: 30000,
      sendTimeout: 30000,
      receiveTimeout: 30000,
    );

    this.options = options;
    interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) async {
        await Future.delayed(const Duration(seconds: 0));
        handler.next(response);
      },
    ));

    interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    httpClientAdapter = DefaultHttpClientAdapter();
  }

  static Dio getInstance() => AppDio._();
}
