import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_wallet/di/repository_provider.dart';

import '../../data/repository/remote/app_api_helper.dart';

abstract class BaseViewModel extends ChangeNotifier {
  BaseViewModel(this._reader);

  final Reader _reader;

  Reader get reader => _reader;

  late final AppApiHelper _appApiHelper = reader(appApiHelperProvider);

  AppApiHelper get appApiHelper => _appApiHelper;

  bool _isBusy = false;

  bool get isBusy => _isBusy;

  bool _isError = false;

  bool get isError => _isError;

  Future<void> init() async {
    setBusy(true);
    await onViewModelReady();
    setBusy(false);
  }

  Future<void> onViewModelReady();

  void setBusy(bool state) {
    _isBusy = state;
    notifyListeners();
  }

  void setError(bool state) {
    _isError = state;
    notifyListeners();
  }
}
