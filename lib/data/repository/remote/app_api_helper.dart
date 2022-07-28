import 'package:my_wallet/data/repository/remote/api_helper.dart';
import 'package:my_wallet/data/repository/remote/api_service_end_point.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_wallet/di/repository_provider.dart';

class AppApiHelper extends ApiHelper {
  AppApiHelper(this._reader);

  final Reader _reader;

  late final ApiServiceEndPoint serviceEndPoint =
      _reader(apiServiceEndPointProvider);

}
