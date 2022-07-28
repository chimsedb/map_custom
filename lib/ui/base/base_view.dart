import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_wallet/ui/base/base_view_model.dart';

abstract class BaseView<T extends BaseViewModel> extends HookConsumerWidget {
  abstract final ChangeNotifierProvider<T> viewModelProvider;

  const BaseView({Key? key}) : super(key: key);

  Future<void> onCreate() async {}

  Widget onViewCreated();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final T viewModel = ref.read(viewModelProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.init();
      onCreate();
    });
    return onViewCreated();
  }
}
