import 'package:my_wallet/data/repository/remote/api_service_end_point.dart';
import 'package:my_wallet/data/repository/remote/app_api_helper.dart';
import 'package:my_wallet/data/repository/remote/app_dio.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final apiServiceEndPointProvider =
    Provider((ref) => ApiServiceEndPoint(ref.read));

final appApiHelperProvider = Provider((ref) => AppApiHelper(ref.read));

final dioProvider = Provider((_) => AppDio.getInstance());
