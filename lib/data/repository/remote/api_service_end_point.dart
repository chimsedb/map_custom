import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_wallet/di/repository_provider.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service_end_point.g.dart';

@RestApi()
abstract class ApiServiceEndPoint {
  factory ApiServiceEndPoint(Reader reader) =>
      _ApiServiceEndPoint(reader(dioProvider));
}
